# Plano de implementação

Etapas definidas com o usuário em 2026-07-29. Vamos por partes — cada etapa é concluída e validada antes de seguir pra próxima.

- [x] **1. SceneDelegate** — remover dependência de storyboard para a UI principal, montar `UINavigationController` raiz em código. (`ViewController` fica como placeholder até a etapa 3)
- [x] **2. Módulo de network** — `Networking/Endpoint.swift` (enum com as 2 URLs) + `Networking/APIClient.swift` (`APIClientProtocol` / `URLSessionAPIClient`, `async/await` sobre `URLSession`, `APIError` simples). Sem Repository ainda — isso vem na etapa 4.
- [x] **3. Telas** — criadas com dados vazios (nenhuma chamada de rede ainda):
  - `Models/Store.swift`, `Models/Menu.swift` (structs `Decodable`, sem lógica — adiantados aqui pois as Views/Cells precisam do shape do dado)
  - `Common/CurrencyFormatter.swift` (cents → "$X.XX")
  - `Features/StoreList/`: `StoreCell`, `StoreListView` (+ `StoreListViewDelegate`/`StoreListViewDisplaying`), `StoreListViewController`
  - `Features/StoreDetail/`: `StoreDetailHeaderView`, `MenuItemCell`, `StoreDetailView` (+ `StoreDetailViewDisplaying`), `StoreDetailViewController` (recebe `Store` no `init`)
  - `SceneDelegate` agora usa `StoreListViewController` como root (removido `ViewController.swift` do template)
  - Pontos deixados com `// TODO (etapa 4)`: wiring do ViewModel, navegação List → Detail, carregamento de imagem
- [x] **4. Comunicação com o network** — feito:
  - Extraído `UITableViewDataSource`/`Delegate` das Views pra um `TableViewHandler` dedicado por tela (`StoreListTableViewHandler`, `StoreDetailTableViewHandler`) — pedido do usuário, mantém a View só com layout/estado.
  - `Repositories/StoreRepository.swift` — `StoreRepositoryProtocol` + `StoreRepositoryDelegate`, único lugar (junto do `APIClient`) que usa `async/await`; fetch dispara `Task`, resultado volta via delegate na main thread.
  - `Features/StoreList/StoreListViewModel.swift` — implementa `StoreRepositoryDelegate`, expõe `StoreListViewModelProtocol`/`StoreListViewModelDelegate` pro Controller.
  - `Features/StoreDetail/StoreDetailViewModel.swift` — mesmo padrão, guarda o `Store` recebido e busca o menu.
  - `StoreListViewController`/`StoreDetailViewController` agora recebem o ViewModel (injeção via `init`, com default), disparam `loadStores()`/`loadMenu()` no `viewDidLoad`, e atualizam a View pelos métodos de `StoreListViewDisplaying`/`StoreDetailViewDisplaying`.
  - Navegação List → Detail: `StoreListViewModelDelegate.viewModel(_:didSelectStore:)` → Controller dá `push` no `StoreDetailViewController(store:)`.
  - `Common/ImageLoader.swift` — download simples (`URLSession` + `NSCache<NSURL, UIImage>`, sem libs). `StoreCell` e `StoreDetailHeaderView` chamam `imageLoader.loadImage(from:)` dentro de uma `Task` própria (cancelada em `prepareForReuse()`/reconfiguração, com checagem de `Task.isCancelled` antes de setar a imagem — evita imagem trocada por reciclo de célula).

- [x] **6. Search** — regras definidas com o usuário:
  - Busca por **nome** da loja (`localizedCaseInsensitiveContains`), aplicada em `StoreListViewModel.search(query:)` sobre `allStores` (cópia intocada do resultado original, separada de `stores`, que é o que a View exibe).
  - **Debounce de 0.5s** via `Task.sleep(nanoseconds: 500_000_000)`, cancelando a task anterior a cada nova chamada (mesmo padrão de `Task` já usado no `StoreRepository`).
  - **Mínimo de 2 caracteres**: abaixo disso, restaura `stores = allStores` na hora (sem debounce).
  - `StoreListViewController` conforma `UISearchResultsUpdating` (repassa o texto pro ViewModel a cada tecla) e `UISearchControllerDelegate` (`willPresentSearchController`/`didDismissSearchController`) pra esconder/mostrar o featured header.
  - **Importante**: quando o header está escondido (busca ativa), a `StoreListView` para de reservar as 3 primeiras posições pro header — a lista passa a mostrar o array inteiro de resultados, e o offset de índice (usado pra resolver a seleção de linha) vira 0 em vez de +3. Sem isso, as 3 primeiras lojas ficariam sem aparecer em lugar nenhum durante a busca.

- [x] **5. Ajuste de UI — destaque das 3 primeiras lojas** — `Features/StoreList/StoreListFeaturedHeaderView.swift`: stack horizontal só com as capas das 3 primeiras lojas, usado como `tableView.tableHeaderView`. A lista vertical passa a mostrar `stores.dropFirst(3)`. Tocar numa imagem do header dispara a mesma navegação de tocar numa linha (`StoreListViewDelegate.storeListView(_:didSelectRowAt:)`), com o índice do header (0-2) e o índice da lista (+3 de offset) convergindo pro mesmo array de `Store` no ViewModel.

## Notas
- Sem Combine, sem closures de binding — tudo via protocolo + delegate (ver [`architecture.md`](./architecture.md)).
- `async/await` fica isolado dentro do Repository.
- Sem libs de terceiros (inclusive para carregar imagem — `ImageLoader` próprio, etapa a definir dentro do passo 3/4).
