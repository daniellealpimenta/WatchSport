# Borda · Permissão e Final · Missão concluída

Data: 2026-08-20
Protótipo de referência: `missao-diaria-watchos-prototipo.html`

## Escopo

Implementar as duas últimas telas do protótipo que ainda não existem no app:

- **Borda · Permissão** — bloqueio quando o HealthKit não autoriza o treino.
- **Final · Missão concluída** — resumo do dia quando todos os exercícios terminam.

Fora de escopo: o item 04 (exercício ativo por repetições), que segue bloqueado em
`HomeView.start(_:)` pelo `guard route.exerciseType == .running`. Consequência aceita: o
desafio não chega a 4/4 rodando o app hoje, então a tela de Missão concluída só é
verificável por `#Preview` até esse fluxo ser ligado.

## Estado anterior

| Tela do protótipo | Feature |
|---|---|
| 01 · Missão diária | `Features/Home` |
| 02 · Pré-exercício | `Features/PreExercise` |
| 03 · Contagem regressiva | `ActiveExercise/Components/ExerciseCountdownView` |
| 04 · Exercício ativo | `Features/ActiveExercise` (existe, não plugado) |
| 05 · Corrida ativa | `Features/Run` |
| 06 · Exercício concluído | `Features/ExerciseCompleted` |
| 07 · Nível do desafio | `Features/ChangeDifficulty` |
| Borda · Permissão | não existe |
| Final · Missão concluída | não existe |

## A · Borda · Permissão

### Gatilho

`RunViewModel.start()` já tem um `catch` que transforma qualquer falha em `errorMessage`,
renderizado como `ErrorStateView`. Passa a separar dois caminhos:

- `RunTrackingError.authorizationDenied` → tela de Permissão.
- Qualquer outro erro, inclusive `.healthDataUnavailable` → continua no `ErrorStateView`.
  `healthDataUnavailable` é limitação de device, não de permissão; "Tentar novamente" ali
  não faria sentido.

### Correção necessária em `HealthKitRunTracking`

Hoje `authorizationDenied` praticamente nunca dispara. O HealthKit **não lança erro** quando
o usuário nega leitura — o status de leitura é privado por design, justamente para não
revelar que o dado existe. O que é observável é a negativa de escrita do `workoutType`.

Depois do `requestAuthorization`, verificar explicitamente:

```swift
guard healthStore.authorizationStatus(for: .workoutType()) == .sharingAuthorized else {
    throw RunTrackingError.authorizationDenied
}
```

Sem isso, a falha real cai no `try HKWorkoutSession(...)` e vira o erro genérico
"Não foi possível iniciar a corrida", que não distingue permissão de qualquer outro problema.

### Limitação assumida do botão "Tentar novamente"

O protótipo propõe "Abrir Ajustes", mas o watchOS **não expõe API pública para abrir os
ajustes de privacidade** — não existe equivalente a `openSettingsURLString`. O HealthKit só
pode ser reautorizado pelo iPhone (app Watch › Privacidade › Saúde).

Além disso, o HealthKit **não reexibe o prompt** depois que o usuário nega uma vez. Portanto
"Tentar novamente" só surte efeito se a pessoa liberar no iPhone e voltar. O corpo do texto
diz isso explicitamente — caso contrário o botão vira armadilha.

### Estrutura

```
Features/Permission/
  PermissionView.swift
  PermissionViewModel.swift
  Builder/PermissionViewBuilder.swift
```

Segue o padrão View/ViewModel/Builder já usado em `ExerciseCompleted` e `PreExercise`.
Não tem `Route` porque não é destino de navegação.

### Composição

Renderizada **dentro** da `RunView`, como novo branch do `ZStack` antes do `errorMessage`,
não como push. Assim "Agora não" volta direto para a Home sem popar dois níveis de stack.
Exige um `onCancel: () -> Void` novo na `RunView`, que a `HomeView` liga em `runRoute = nil`.

`RunViewModel` ganha:

- `private(set) var needsHealthPermission = false`
- `func retry() async` — limpa o estado e chama `start()` de novo.

### Visual (fiel ao protótipo)

O protótipo mede 398×486 px, ~2× os pontos lógicos do watchOS. Os valores abaixo já estão
convertidos e alinhados às convenções do app.

| Elemento do protótipo | Realização |
|---|---|
| `.permission-icon` 92px, `rgba(255,159,10,.12)`, ícone 43px warning | círculo 56pt, `Color.warning.opacity(0.12)`, `exclamationmark.shield.fill` 28pt em `Color.warning` |
| `.center-copy .big-title` 27px/760 | 22pt bold, `Color.textPrimary`, `lineLimit(2)` + `minimumScaleFactor(0.8)` |
| `.center-copy p` 13px | 13pt regular, `Color.textSecondary`, centralizado |
| `.primary-watch-button` (branco, sem `.accent`) | `AppButton(variant: .light)` — "Tentar novamente" |
| `.watch-secondary-button` (cinza) | `AppButton(variant: .dark)` — "Agora não" |
| `.watch-nav h3` "Permissão" | `.navigationTitle("Permissão")` |

O protótipo usa deliberadamente o botão branco e não o gradiente aqui: permissão não é uma
ação celebratória. Mantido.

## B · Final · Missão concluída

### Estrutura

```
Features/MissionCompleted/
  MissionCompletedRoute.swift
  MissionCompletedView.swift
  MissionCompletedViewModel.swift
  Builder/MissionCompletedViewBuilder.swift
  Components/MissionStreakPill.swift
  Components/MissionSummaryRow.swift
```

`MissionCompletedRoute` precisa ser `Hashable` para o `navigationDestination(item:)`, então
carrega valores puros — não `PersistentIdentifier` nem referências ao SwiftData:

```swift
struct MissionCompletedRoute: Hashable {
    let summary: [ExerciseSummary]
    let streakDays: Int
}

struct ExerciseSummary: Hashable {
    let exerciseType: ExerciseType
    let completedAmount: Double
}
```

`MissionCompletedViewModel` deriva os textos ("N de N exercícios · 100%", "Sequência de N
dias") e formata cada linha pela unidade via `ExerciseAmountFormatter`. Nenhum valor
hardcodado: a contagem vem do tamanho de `summary`, não da constante 4.

### Integração

`HomeView.backToChallenge()` passa a checar `dailyChallenge?.isCompleted`. Se 100%, empilha
`missionCompletedRoute` por cima da `ExerciseCompleted`; senão, zera as rotas e volta para a
Home como hoje. O botão "Concluir" zera todas as rotas.

Nenhuma lógica de dados nova é necessária: `DailyChallengeService.completeExercise` já marca
`challenge.completedAt` quando todos os exercícios terminam, e `HomeViewModel.currentStreak`
já calcula a sequência.

### Visual

O protótipo usa a mesma classe `.success-mark` nas telas "Exercício concluído" e "Missão
concluída". O app já materializou essa marca como `CompletionBadge` (gradiente em vez do
verde do protótipo — desvio feito no item 06, fora de escopo). Reusar `CompletionBadge`
mantém as duas telas coerentes entre si dentro do app.

| Elemento do protótipo | Realização |
|---|---|
| `.success-mark` | `CompletionBadge` (reuso) |
| `.success-view h2` "Missão concluída" | 18pt bold `textPrimary` — mesmo mapeamento já usado em `ExerciseCompletedView` |
| `.success-view .result` 16px/620 | 14pt semibold `textSecondary` |
| `.mission-gain` pill, `rgba(181,140,255,.15)`, 12px | `MissionStreakPill`: `Capsule`, `Color.brandPurple.opacity(0.15)`, `flame.fill` + "Sequência de N dias", 12pt, `Color.brandPurple` |
| `.summary-row` 48px, `--watch-surface`, R16, 14px | `MissionSummaryRow`: `minHeight 44`, `Color.surface`, `cornerRadius 12 .continuous`, `padding(.horizontal, 12)`, nome 14pt regular `textSecondary`, valor 15pt bold rounded `monospacedDigit` `textPrimary` |
| `.summary-list` gap 7px | `VStack(spacing: 6)` |
| botão de saída (ausente no protótipo) | `AppButton("Concluir", variant: .gradient)` |

`MissionStreakPill` existe em vez de reusar `StreakBadge` porque o `StreakBadge` da Home
mostra só o número, sem o rótulo "Sequência de N dias" que o protótipo pede aqui.

## Fora do PR

O `project.pbxproj` tem alterações locais de assinatura (`DEVELOPMENT_TEAM`, bundle id) e a
pasta `xcshareddata/` está untracked. Ambos ficam de fora dos commits — são configuração de
máquina, não da feature.

O alvo usa `PBXFileSystemSynchronizedRootGroup`, então os arquivos novos entram no target
automaticamente e o `pbxproj` não precisa ser editado.
