import Foundation
import Combine
import ComposableArchitecture

extension Publisher where Failure: Error {

    func catchToResult() -> AnyPublisher<TaskResult<Output>, Never> {
        self.map { TaskResult.success($0) }
        .catch { error in
            return Just(.failure(error))
        }
        .eraseToAnyPublisher()
    }

}
