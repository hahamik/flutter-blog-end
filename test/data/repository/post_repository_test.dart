import 'package:flutter_blog/data/repository/post_repository.dart';

void main() async {
  PostRepository repo = PostRepository();
  await repo.getList();
}
