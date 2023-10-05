abstract class UseCase<Input, Output> {
  Output run(Input input);
}

abstract class OutputUseCase<Output> {
  Output run();
}

abstract class StreamUseCase<Input, Output> {
  Stream<Output> run(Input input);
}

abstract class StreamOutputUseCase<Output> {
  Stream<Output> run();
}

abstract class FutureUseCase<Input, Output> {
  Future<Output> run(Input input);
}

abstract class FutureOutputUseCase<Output> {
  Future<Output> run();
}

abstract class FutureUseCaseTwoInput<Input1, Input2, Output> {
  Future<Output> run(Input1 input1, Input2 input2);
}
