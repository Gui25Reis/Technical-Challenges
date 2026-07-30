# Arquitetura — DoordashAI

Documento vivo com as decisões de arquitetura alinhadas com o usuário. Atualizar conforme a implementação avança.

## Contexto

Projeto de teste (`DoordashAI/problem.md`) com 2 telas:
1. **Store List** — lista de lojas (`GET /feed`)
2. **Store Detail** — detalhe da loja + menu (`GET /menu`)

Tempo é limitado — o foco é ter a base de rede funcionando e as telas se comunicando com ela; refinamento de UI é secundário.

## Decisões

| Decisão | Escolha | Motivo |
| --- | --- | --- |
| UI Framework | UIKit programático (sem Storyboard/XIB para as telas de feature) | Preferência do usuário |
| Padrão de arquitetura | MVVM + Repository | Boa separação de responsabilidades, testável |
| Reatividade / binding | **Nenhuma lib reativa** (sem Combine, sem closures de binding) | Usuário não tem familiaridade com Combine e prefere protocolos/delegate, que é o padrão clássico UIKit |
| Comunicação entre camadas | **Protocolo + Delegate** em toda camada (View↔Controller, Controller↔ViewModel, ViewModel↔Repository) | Preferência explícita do usuário |
| Chamada de rede | `async/await` (nativo, `URLSession`) | Preferência do usuário; fica encapsulado dentro do Repository — as camadas acima só recebem callbacks via delegate |
| Libs de terceiros | Nenhuma (requisito do problema) | Inclui carregamento de imagem — precisa de um `ImageLoader` próprio |

## Camadas e contratos

```
App/
├── AppDelegate.swift
└── SceneDelegate.swift          → monta a UINavigationController raiz em código

Models/
├── Store.swift                  → struct Codable
└── Menu.swift                   → Menu + MenuItem, Codable

Networking/
├── Endpoint.swift                → define as URLs/requests dos 2 endpoints
└── APIClient.swift               → protocolo + impl (async/await sobre URLSession)

Repositories/
└── StoreRepository.swift         → protocolo + impl; delegate-based

Features/
├── StoreList/
│   ├── StoreListViewModel.swift
│   ├── StoreListViewController.swift
│   ├── StoreListView.swift
│   ├── StoreListTableViewHandler.swift  → UITableViewDataSource/Delegate isolados
│   └── StoreCell.swift
└── StoreDetail/
    ├── StoreDetailViewModel.swift
    ├── StoreDetailViewController.swift
    ├── StoreDetailView.swift
    ├── StoreDetailTableViewHandler.swift
    ├── StoreDetailHeaderView.swift
    └── MenuItemCell.swift

Common/
├── ImageLoader.swift              → cache simples (NSCache) + download assíncrono (protocol ImageLoading, sem libs)
└── CurrencyFormatter.swift        → cents -> "$X.XX"
```

### Networking

```swift
protocol APIClientProtocol {
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}
```
Único ponto do app com `async/await` "puro". Chamado internamente pelo Repository.

### Repository — delegate-based

```swift
protocol StoreRepositoryProtocol: AnyObject {
    var delegate: StoreRepositoryDelegate? { get set }
    func fetchStores()
    func fetchMenu()
}

protocol StoreRepositoryDelegate: AnyObject {
    func repository(_ repository: StoreRepositoryProtocol, didFetchStores stores: [Store])
    func repository(_ repository: StoreRepositoryProtocol, didFetchMenu menu: Menu)
    func repository(_ repository: StoreRepositoryProtocol, didFailWithError error: Error)
}
```
Por dentro, `fetchStores()`/`fetchMenu()` abrem uma `Task` que faz `await apiClient.fetch(...)` e, ao final, chamam o delegate na main thread.

### ViewModel — delegate-based (implementa `StoreRepositoryDelegate`, expõe protocolo próprio pro Controller)

```swift
protocol StoreListViewModelProtocol: AnyObject {
    var delegate: StoreListViewModelDelegate? { get set }
    var stores: [Store] { get }
    func loadStores()
    func didSelectStore(at index: Int)
}

protocol StoreListViewModelDelegate: AnyObject {
    func viewModelDidUpdateStores(_ viewModel: StoreListViewModelProtocol)
    func viewModel(_ viewModel: StoreListViewModelProtocol, didFailWithError message: String)
    func viewModel(_ viewModel: StoreListViewModelProtocol, didSelectStore store: Store)
}
```
(simplificado de `numberOfStores`/`store(at:)` pra `var stores: [Store] { get }` na implementação — menos boilerplate, o Controller só repassa o array pra View)

O mesmo padrão vale pro `StoreDetailViewModel` (`var store: Store`, `var menuItems: [MenuItem]`, `loadMenu()`), implementando `StoreRepositoryDelegate` e expondo `StoreDetailViewModelDelegate` pro Controller.

### Controller ↔ View — separados, comunicando por protocolo

```swift
protocol StoreListViewDelegate: AnyObject {
    func storeListView(_ view: StoreListView, didSelectRowAt index: Int)
}

protocol StoreListViewDisplaying: AnyObject {
    func reloadData()
    func showLoading()
    func showError(_ message: String)
}
```
O Controller implementa `StoreListViewModelDelegate` e `StoreListViewDelegate`; a `View` (UIView customizada dona da `UITableView`) implementa `StoreListViewDisplaying`.

### TableViewHandler — datasource/delegate isolados da View

A `UITableViewDataSource`/`UITableViewDelegate` não fica na `View` nem no `Controller`: cada tela tem um `TableViewHandler` próprio (`StoreListTableViewHandler`, `StoreDetailTableViewHandler`), um `NSObject` que só sabe renderizar células e (quando aplicável) notificar seleção via delegate. A `View` cria o handler, seta `tableView.dataSource/delegate = handler` e repassa `update(...)` pra ele. Isso mantém a `View` focada em layout/estado (loading/erro) e o handler focado só na tabela — mais fácil de testar/isolar cada responsabilidade.

```swift
protocol StoreListTableViewHandlerDelegate: AnyObject {
    func tableViewHandler(_ handler: StoreListTableViewHandler, didSelectStoreAt index: Int)
}

final class StoreListTableViewHandler: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: StoreListTableViewHandlerDelegate?
    // numberOfRowsInSection / cellForRowAt / didSelectRowAt
}
```
A `View` conforma `StoreListTableViewHandlerDelegate` e repassa a seleção pro seu próprio `StoreListViewDelegate` (Controller).

## Nota técnica — Xcode project

O `.xcodeproj` usa **file-system-synchronized groups** (recurso do Xcode 16+): qualquer arquivo/pasta criado dentro de `DoordashAI/DoordashAI/` entra automaticamente no target, sem precisar editar `project.pbxproj` na mão.

## Roteiro de implementação

Ver [`plano.md`](./plano.md) para o passo a passo e status de cada etapa.
