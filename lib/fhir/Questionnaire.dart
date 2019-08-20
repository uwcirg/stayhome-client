/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

class Questionnaire {
  String resourceType;
  String id;
  Meta meta;
  String version;
  String title;
  String status;
  String description;
  List<QuestionnaireItem> item;

  Questionnaire(
      {this.resourceType,
        this.id,
        this.meta,
        this.version,
        this.title,
        this.status,
        this.description,
        this.item});

  Questionnaire.fromJson(Map<String, dynamic> json) {
    resourceType = json['resourceType'];
    id = json['id'];
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    version = json['version'];
    title = json['title'];
    status = json['status'];
    description = json['description'];
    if (json['item'] != null) {
      item = new List<QuestionnaireItem>();
      json['item'].forEach((v) {
        item.add(new QuestionnaireItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resourceType'] = this.resourceType;
    data['id'] = this.id;
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    data['version'] = this.version;
    data['title'] = this.title;
    data['status'] = this.status;
    data['description'] = this.description;
    if (this.item != null) {
      data['item'] = this.item.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meta {
  String versionId;
  String lastUpdated;

  Meta({this.versionId, this.lastUpdated});

  Meta.fromJson(Map<String, dynamic> json) {
    versionId = json['versionId'];
    lastUpdated = json['lastUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['versionId'] = this.versionId;
    data['lastUpdated'] = this.lastUpdated;
    return data;
  }
}

class QuestionnaireItem {
  String linkId;
  String text;
  bool required;
  List<AnswerOption> answerOption;

  QuestionnaireItem({this.linkId, this.text, this.required, this.answerOption});

  QuestionnaireItem.fromJson(Map<String, dynamic> json) {
    linkId = json['linkId'];
    text = json['text'];
    required = json['required'];
    if (json['answerOption'] != null) {
      answerOption = new List<AnswerOption>();
      json['answerOption'].forEach((v) {
        answerOption.add(new AnswerOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['linkId'] = this.linkId;
    data['text'] = this.text;
    data['required'] = this.required;
    if (this.answerOption != null) {
      data['answerOption'] = this.answerOption.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnswerOption {
  int valueInteger;

  AnswerOption({this.valueInteger});

  AnswerOption.fromJson(Map<String, dynamic> json) {
    valueInteger = json['valueInteger'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['valueInteger'] = this.valueInteger;
    return data;
  }
}

