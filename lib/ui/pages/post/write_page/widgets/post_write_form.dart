import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_vm.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_text_area.dart';
import 'package:flutter_blog/ui/widgets/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostWriteForm extends ConsumerWidget {
  late String title;
  late String content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PostListVM vm = ref.read(postListProvider.notifier);
    return Form(
      child: ListView(
        shrinkWrap: true,
        children: [
          CustomTextFormField(
            hint: "Title",
            onChanged: (value) {
              title = value;
            },
          ),
          const SizedBox(height: smallGap),
          CustomTextArea(
            hint: "Content",
            onChanged: (value) {
              content = value;
            },
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "글쓰기",
            click: () {
              vm.write(title, content);
            },
          ),
        ],
      ),
    );
  }
}
