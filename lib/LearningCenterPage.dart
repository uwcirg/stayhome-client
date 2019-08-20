/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/i18n.dart';

class LearningCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
      title: S.of(context).learning_center,
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.halfMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LearningCenterCard(S.of(context).vfit_faq,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => FAQPage(FAQ.faqs())))),
            LearningCenterCard(
              S.of(context).womens_health_resources,
            ),
            LearningCenterCard(
              S.of(context).testimonials,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        TestimonialsPage(Testimonial.testimonials())),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LearningCenterCard extends StatelessWidget {
  final String text;
  final Function onTap;

  LearningCenterCard(this.text, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Card(
          child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.largeMargin,
                  horizontal: Dimensions.fullMargin),
              child: Text(
                text,
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.center,
              )),
        ),
        onTap: onTap);
  }
}

class Testimonial {
  final String quote;
  final String name;

  Testimonial(this.quote, this.name);

  static List<Testimonial> testimonials() {
    return [
      Testimonial(
          "This is a great product. Has given me a new lease of life and is so quick and easy to use. Would recommend it.",
          "Tanhya"),
      Testimonial(
          "After menopause, I could no longer have pleasurable intercourse. This product changed all that and gave me so much confidence and desire to be intimate again.",
          "Barbara"),
      Testimonial(
          "Before using vFit, I lacked sexual confidence after having a baby. Thanks to vFit, my sex drive is back and sex is pleasurable again.",
          "Kristina"),
    ];
  }
}

class TestimonialWidget extends StatelessWidget {
  final Testimonial _testimonial;

  TestimonialWidget(this._testimonial);

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).accentTextTheme.body1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.halfMargin),
              child: Text.rich(TextSpan(
                style: TextStyle(height: 1.4),
                children: <InlineSpan>[
                  WidgetSpan(
                      child: Icon(
                    Icons.format_quote,
                    color: Colors.white,
                  )),
                  TextSpan(text: _testimonial.quote, style: textStyle),
                  WidgetSpan(
                      child: Icon(Icons.format_quote, color: Colors.white)),
                ],
              )),
            )),
        Padding(
          padding: const EdgeInsets.all(Dimensions.halfMargin),
          child: Text(
            "- ${_testimonial.name}",
            style: textStyle,
            textAlign: TextAlign.end,
          ),
        )
      ],
    );
  }
}

class TestimonialsPage extends StatelessWidget {
  final List<Testimonial> _testimonials;

  TestimonialsPage(this._testimonials);

  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
        backgroundColor: Theme.of(context).accentColor,
        title: S.of(context).testimonials,
        showDrawer: false,
        child: Expanded(
            child: ListView.builder(
          padding: const EdgeInsets.all(Dimensions.halfMargin),
          itemBuilder: (context, i) {
            return TestimonialWidget(_testimonials[i]);
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
