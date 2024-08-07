import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:planZ/app_state.dart';
import 'package:planZ/common/dart/extension/context_extension.dart';

class JourneyPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const JourneyPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    String currentLanguage = AppLangState.instance.appLanguage;

    List<String> hashtags = [];
    String journeyName = item['translated_title']?[currentLanguage] ?? 'No Name';
    String description =  item['translated_description']?[currentLanguage] ?? 'No Description';

    if (item['translated_hashtags'] != null) {
      var translatedHashtags = item['translated_hashtags'];
      for (var i = 0; i < translatedHashtags.length; i++) {
        hashtags.add(translatedHashtags[i.toString()][currentLanguage]);
      }
    }

    return Column(
      children: [
        //image carousel

        //joureny info
        Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              children: [
                //first line
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        journeyName,
                        style:
                            TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text('@kiyeorida')
                  ],
                ),
                //second line
                Padding(
                  padding: EdgeInsets.only(top: 9, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: hashtags.isNotEmpty
                            ? Wrap(
                                spacing: 12.0,
                                children: hashtags.map((hashtag) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0,
                                          color: context.appColors.mainGray),
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Text(
                                      '# $hashtag',
                                      style: const TextStyle(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            : const Text(
                                'Loading hashtags...',
                                style: TextStyle(
                                    fontSize: 10.0, color: Colors.white),
                              ),
                      ),
                      SvgPicture.asset(
                        'assets/image/icon/Save.svg',
                        width: 24,
                        height: 24,
                      )
                    ],
                  ),
                ),
                //third line
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        description,
                        style:
                            TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                    SvgPicture.asset('assets/image/icon/Add.svg')
                  ],
                )
              ],
            ),
          ),
        ),

        Container(
          height: 10,
          color: context.appColors.baseGray,
        ),

        //journey spot
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //first line
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mount Halla', style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24
                      ),
                      ),
                      SvgPicture.asset('assets/image/icon/Save.svg')
                    ],
                  ),
                  const SizedBox(height: 12,),
                  Text('An easy hike through green forests of a dormant volcano.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400
                  ),)
                ],
              ),
              ),
              const SizedBox(height: 20,),

            ],
          ),
        )
      ],
    );
  }
}
