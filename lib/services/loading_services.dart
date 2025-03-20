class LoadingService {
  Future<void> simulateLoading() async {
    await Future.delayed(Duration(seconds: 3));
  }
}