import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/ui/pages/auth/join_page/join_fm.dart';
import 'package:flutter_blog/ui/widgets/custom_auth_text_form_field.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_text_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinForm extends ConsumerWidget {
  const JoinForm({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    JoinFM fm = ref.read(joinProvider.notifier);
    JoinModel model = ref.watch(joinProvider);
    return Form(
      child: Column(
        children: [
          CustomAuthTextFormField(
            text: "Username",
            onChanged: (value) {
              fm.username(value);
              print("창고 상태 : ${model.toString()}");
            },
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            text: "Email",
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            text: "Password",
            obscureText: true,
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "회원가입",
            click: () {},
          ),
          CustomTextButton(
            text: "로그인 페이지로 이동",
            click: () {
              Navigator.pushNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}
