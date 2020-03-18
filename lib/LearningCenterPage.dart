/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:map_app_flutter/platform_stub.dart';
import 'package:scoped_model/scoped_model.dart';

import 'main.dart';

abstract class LearningCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
      title: S.of(context).learning_center,
      child: ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
        if (model.isLoading || model.infoLinks == null) {
          model.loadResourceLinks();
          return Center(child: CircularProgressIndicator());
        } else if (model.error != null) {
          return Text('${model.error}');
        }
        return Expanded(
            child: ListView.separated(
          primary: true,
          separatorBuilder: (context, i) => Divider(),
          itemBuilder: (context, i) => _buildItem(context, i, model),
          itemCount: _itemCount(model),
          shrinkWrap: true,
        ));
      }),
    );
  }

  Widget _buildItem(BuildContext context, int i, CarePlanModel model);

  int _itemCount(CarePlanModel model);

  Widget _buildLearningCenterListItem(BuildContext context, String text, {Function onTap}) {
    return InkWell(
        child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.largeMargin, horizontal: Dimensions.fullMargin),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).textTheme.body1.color,
                )
              ],
            )),
        onTap: onTap);
  }
}

class JoyluxLearningCenterPage extends LearningCenterPage {
  @override
  Widget _buildItem(BuildContext context, int i, CarePlanModel model) {
    switch (i) {
      case 0:
        return _buildLearningCenterListItem(context, S.of(context).vfit_faq,
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) => FAQPage(FAQ.faqs()))));
      case 1:
        return _buildLearningCenterListItem(context, S.of(context).womens_health_resources);
      default:
        return _buildLearningCenterListItem(
          context,
          S.of(context).testimonials,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context) => TestimonialsPage(Testimonial.testimonials())),
          ),
        );
    }
  }

  @override
  int _itemCount(CarePlanModel model) {
    return 3;
  }
}

class StayHomeLearningCenterPage extends LearningCenterPage {
  @override
  Widget _buildItem(BuildContext context, int i, CarePlanModel model) {
    return _buildLearningCenterListItem(context, model.infoLinks[i].description,
        onTap: () => model.infoLinks[i].url.isEmpty
            ? snack("No content", context)
            : PlatformDefs().launchUrl(model.infoLinks[i].url));
  }

  @override
  int _itemCount(CarePlanModel model) {
    return model != null && model.infoLinks != null ? model.infoLinks.length : 0;
  }
}

class Testimonial {
  final String quote;
  final String name;

  Testimonial(this.quote, this.name);

  static List<Testimonial> testimonials() {
    return [
      Testimonial(
          "I am a 59 year old woman... this product gave me so much confidence and desire to be intimate again. I have recommended it to close friends and now to you. Trust me, it works, is painless and in fact, pleasurable.",
          "Barbara"),
      Testimonial(
          "Before using vFit, I lacked sexual confidence after having a baby. Thanks to vFit, my sex drive is back and sex is pleasurable again.",
          "Tanhya"),
      Testimonial(
          "I appreciate that a company has finally created something to help with many womanly issues. It was easy to use and comfortable.",
          "Kristina"),
      Testimonial(
          "This has made me feel more confident in spontaneous intimacy with my husband. We both notice the change and have found intercourse to be much more enjoyable. I am way more sensitive and he definitely feels a difference. Orgasms are heightened!",
          "Maryanne"),
    ];
  }
}

class TestimonialWidget extends StatelessWidget {
  final Testimonial _testimonial;

  TestimonialWidget(this._testimonial);

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.subhead;
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: Dimensions.borderWidth),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).highlightColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.fullMargin),
          child: Column(
            children: <Widget>[
              buildTestimonialText(context, textStyle),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "- ${_testimonial.name}",
                    style: textStyle,
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Text buildTestimonialText(BuildContext context, TextStyle textStyle) {
    if (kIsWeb) {
      return Text(
        _testimonial.quote,
        style: textStyle,
      );
    }
    return Text.rich(TextSpan(
      children: <InlineSpan>[
        WidgetSpan(
          child: Transform.rotate(
            angle: 3.1492,
            child: Icon(
              Icons.format_quote,
              color: Theme.of(context).textTheme.body1.color,
              size: 20,
            ),
          ),
        ),
        TextSpan(text: _testimonial.quote, style: textStyle),
        WidgetSpan(
          child: Icon(
            Icons.format_quote,
            color: Theme.of(context).textTheme.body1.color,
            size: 20,
          ),
          alignment: ui.PlaceholderAlignment.top,
        ),
      ],
    ));
  }
}

class TestimonialsPage extends StatelessWidget {
  final List<Testimonial> _testimonials;

  TestimonialsPage(this._testimonials);

  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
        title: S.of(context).testimonials,
        showDrawer: false,
        child: Expanded(
            child: ListView.builder(
          padding: const EdgeInsets.all(Dimensions.fullMargin),
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.halfMargin),
              child: TestimonialWidget(_testimonials[i]),
            );
          },
          itemCount: _testimonials.length,
          shrinkWrap: true,
        )));
  }
}

class FAQ {
  final String question;
  final String answer;

  FAQ(this.question, this.answer);

  static List<FAQ> faqs() {
    return [
      FAQ("What are vFit and vFit PLUS?",
          "vFit and vFit PLUS are two of the world’s first non-hormonal, non-invasive intimate wellness solutions that use a patented combination of low level light, gentle heat, and sonic technology to encourage blood flow, which aids natural hydration, and help you improve moisture, sensation, pleasure, and intimacy, all from the privacy of your home.\nvFit PLUS is our professional model, available exclusively through medical professionals, with additional features to allow you to experience better results faster."),
      FAQ("Are vFit or vFit PLUS products FDA approved?",
          "The FDA designated vFit and vFit PLUS as Low-Risk General Wellness Devices in December 2017, allowing us to legally market and sell our devices for intimate wellness. Want to know more? Click here."),
      FAQ("How do I use vFit and vFit PLUS?",
          "Getting started is easy! First, be sure to charge your vFit or vFit PLUS for at least 24 hours before first use. We recommend you use a clear, water-based gel to help with insertion of the device. Apply a desired amount of gel – a dime-sized amount is a good starting point. (We created our Photonic Gel for use with vFit and vFit PLUS.) Next, turn on your vFit or vFit PLUS by pressing the power button. Choose your light mode and press the button to get started. Then lie back, relax, and know you're improving your intimate wellness.\nFor more information on how to use vFit and vFit PLUS, check out our video tutorial."),
      FAQ("How long should I use vFit or vFit PLUS?",
          "Use your device regularly. As with any exercise regimen, it takes time to notice results. In a consumer study, women used their devices every other day for 10 minutes per day. Over the course of 60 days, women noticed an improvement in intimate wellness, enhanced comfort and pleasure with intercourse, and increased confidence. They then used the device on an ongoing basis, once or twice per week for maintenance. As we all know, you must continue to work out in order to maintain your great results.\nIf you have the professional model, vFit PLUS, work up to using your device 12 minutes every other day."),
      FAQ("How do I clean vFit and vFit PLUS?",
          "vFit and vFit PLUS are made with body-safe, medical grade silicone and are easy to clean. Using a soft, non-abrasive cloth, gently clean your vFit or vFit PLUS with warm water and antibacterial soap prior to first use and after each subsequent use. Rinse your vFit or vFit PLUS thoroughly to ensure all soap residue is removed. Let your vFit or vFit PLUS air dry and store in a cool, dry location protected from dirt and dust.\nDon’t immerse your vFit or vFit PLUS in water or place in a dishwasher, sterilizer, or autoclave. Don’t use cleaning solutions which may damage your vFit or vFit PLUS and their electronics or allow the electronic controls and charging port to get wet."),
      FAQ("Do vFit and vFit PLUS have a warranty?",
          "Yes. vFit and vFit PLUS each have a one-year warranty against manufacturer defect-related problems resulting from normal use of the product. In order to activate your warranty, please register your vFit or vFit PLUS."),
      FAQ("What is Photonic Gel?",
          "Photonic Gel is a premium, ultra-concentrated, water-based lubricant that is infused with hyaluronic acid and aloe to help moisturize. Our gel is formulated specifically to address dryness and will enhance the performance and comfort of your vFit or vFit PLUS."),
      FAQ("Is vFit - or vFit PLUS - right for me?",
          "vFit and vFit PLUS are intimate wellness devices. They are not intended to treat or prevent any medical condition. If you are unsure whether or not you should use vFit or vFit PLUS, please consult your physician.\nIf you're currently under a doctor’s care for any pelvic floor-related conditions, please consult your physician before using vFit or vFit PLUS. Do not use if you are pregnant or believe you may be pregnant. Do not use if you are using cancer-fighting drugs, medications, or topical creams that increase photosensitivity.\nTo learn more and determine whether vFit or vFit PLUS is best for you, take our quiz."),
      FAQ("What are the differences between vFit and vFit PLUS?",
          "vFit PLUS has more LED power than our original vFit model, an additional 12-minute treatment time, and 10 vibration modes compared to vFit's six vibration modes. The device’s added power, time, and features allow you to achieve maximum results faster."),
      FAQ("Where can I buy vFit PLUS?",
          "vFit PLUS is available exclusively at professional offices. Visit our Professional Locator to find one nearest you."),
      FAQ("Are online auction and marketplace sites (such as eBay and Groupon) authorized resellers of vFit, vFit PLUS or Photonic Gel?",
          "No, online auction and marketplace sites (such as eBay and Groupon) are not authorized retailers of vFit, vFit PLUS or Photonic Gel. If you purchase from an unauthorized institution, our product(s) may be diluted, expired, or counterfeit. They may not be safe to use or perform as tested. Item(s) purchased on online auction and marketplace sites will void the one-year manufacture warranty.\nvFit PLUS is sold exclusively through medical professionals. Visit our Professional Locator section to find the professional nearest you. \nIn addition to purchasing on getvfit.com, visit any of the authorized resellers below to purchase vFit:\nCurrentBody\nSeriously Smart Technologies\nTruth in Aging"),
    ];
  }
}

class FAQWidget extends StatelessWidget {
  final FAQ _faq;

  FAQWidget(this._faq);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(_faq.question),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(Dimensions.fullMargin),
          child: Text(_faq.answer),
        )
      ],
    );
  }
}

class FAQPage extends StatelessWidget {
  final List<FAQ> _faqs;

  FAQPage(this._faqs);

  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
        title: S.of(context).vfit_faq,
        showDrawer: false,
        child: Expanded(
            child: ListView.builder(
          itemBuilder: (context, i) {
            return FAQWidget(_faqs[i]);
          },
          itemCount: _faqs.length,
          shrinkWrap: true,
        )));
  }
}
