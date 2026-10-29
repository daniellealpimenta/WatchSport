<div align="center">

# ⌚ WatchSport

**Uma missão de treino por dia, direto no pulso.**

App para Apple Watch que entrega um desafio diário com quatro exercícios (flexão, abdominal,
agachamento e corrida). As repetições são contadas pelos sensores de movimento do relógio e a
corrida é medida com uma sessão de treino do HealthKit.

![Swift](https://img.shields.io/badge/Swift-5-F05138?logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-0175C2?logo=swift&logoColor=white)
![watchOS](https://img.shields.io/badge/watchOS-26-000000?logo=apple&logoColor=white)
![HealthKit](https://img.shields.io/badge/HealthKit-workout%20session-FF2D55?logo=apple&logoColor=white)
![Core Motion](https://img.shields.io/badge/Core%20Motion-acelerômetro%20%2B%20giroscópio-000000?logo=apple&logoColor=white)
![SwiftData](https://img.shields.io/badge/SwiftData-000000?logo=apple&logoColor=white)
![SPM](https://img.shields.io/badge/SPM-ExercisesPackage-F05138?logo=swift&logoColor=white)

</div>

<!--
  TODO: gravar prints do simulador do Apple Watch em docs/screenshots/ e descomentar.
<p align="center">
  <img src="docs/screenshots/home.png" width="180" alt="Missão diária" />
  <img src="docs/screenshots/exercicio.png" width="180" alt="Exercício ativo" />
  <img src="docs/screenshots/corrida.png" width="180" alt="Corrida" />
  <img src="docs/screenshots/missao-concluida.png" width="180" alt="Missão concluída" />
</p>
-->

> [!NOTE]
> Projeto em equipe da **Apple Developer Academy | UCB**. A contagem de repetições vem do
> [**ExercisesPackage**](https://github.com/daniellealpimenta/ExercisesPackage), um Swift
> Package criado para este app.

---

## ✨ O que ele faz

| | |
|---|---|
| 🎯 **Missão diária** | Quatro exercícios por dia, com anel de progresso e sequência de dias (*streak*) |
| 📶 **Três níveis** | Fácil, médio e difícil: de 5 flexões e 500 m até 20 flexões e 3 km |
| 💪 **Repetições automáticas** | Flexão, abdominal e agachamento contados pelo acelerômetro e giroscópio |
| 🏃 **Corrida real** | `HKWorkoutSession` + `HKLiveWorkoutBuilder` medindo a distância ao vivo |
| ⏱️ **Contagem regressiva** | 3, 2, 1 antes de cada exercício |
| 🔐 **Permissão tratada** | Tela própria quando o app Saúde nega acesso, separada de erros de aparelho |
| 🏁 **Missão concluída** | Resumo do dia quando os quatro exercícios terminam |
| 🧪 **Roda no simulador** | Sem HealthKit no simulador, uma corrida simulada entra no lugar |

### Metas por nível

| Nível | Flexões | Abdominais | Agachamentos | Corrida |
|---|---:|---:|---:|---:|
| Fácil | 5 | 10 | 10 | 500 m |
| Médio | 10 | 20 | 20 | 1,5 km |
| Difícil | 20 | 40 | 40 | 3 km |

## 🧱 Arquitetura

**MVVM por feature**, com *Builder* para montar as dependências e *Route* para a navegação de
cada tela:

```
WatchSport Watch App/
├── Core/Config/         metas por nível e chaves de UserDefaults
├── Models/              DailyChallenge e DailyExercise (@Model, SwiftData)
├── Services/
│   ├── DailyChallengeService.swift   cria o desafio do dia, conclui exercícios, muda nível
│   ├── RunTracking.swift             protocolo da fonte de distância
│   ├── HealthKitRunTracking.swift    implementação real (aparelho)
│   └── SimulatedRunTracking.swift    implementação de simulador
├── Features/
│   └── <Feature>/       View + ViewModel + Route + Builder + Components
│       Home · PreExercise · ActiveExercise · Run · ExerciseCompleted
│       MissionCompleted · ChangeDifficulty · Permission · Onboarding
└── Shared/              botões, barra de progresso, estado de erro, formatadores
```

- **Inversão de dependência na corrida**: as telas dependem do protocolo `RunTracking`; o
  `RunViewBuilder` injeta HealthKit no aparelho e a versão simulada com
  `#if targetEnvironment(simulator)`.
- **Permissão do HealthKit feita do jeito certo**: o HealthKit não revela se a *leitura* foi
  negada. O app verifica a autorização de *escrita* do treino, que é observável, e só então
  mostra a tela de permissão.
- **Fluxo de trabalho**: cada funcionalidade entrou por *pull request*, com spec escrita antes
  ([`docs/`](docs/)) e commits no padrão *Conventional Commits*.

## 🚀 Primeiros passos

```bash
git clone https://github.com/daniellealpimenta/WatchSport.git
open WatchSport/WatchSport/WatchSport.xcodeproj
```

1. O Xcode baixa o `ExercisesPackage` pelo Swift Package Manager.
2. Escolha o seu time em *Signing & Capabilities* (capability **HealthKit**).
3. Rode no simulador do Apple Watch para navegar, ou num relógio real (watchOS 26) para contar
   repetições e medir a corrida.

## 👥 Time

[**Daniel Leal Pimenta**](https://github.com/daniellealpimenta),
[Lizandra Malta](https://github.com/lizandramalta),
[@silvaaszx](https://github.com/silvaaszx) e
[@jfelipeschwaab](https://github.com/jfelipeschwaab).

## 🗺️ Roadmap

- [x] Missão diária com quatro exercícios e três níveis
- [x] Corrida com HealthKit e contagem regressiva
- [x] Repetições automáticas via ExercisesPackage
- [x] Telas de permissão e de missão concluída
- [ ] Notificação diária lembrando a missão
- [ ] Complication com o progresso do dia
- [ ] Testes de unidade para o `DailyChallengeService`
