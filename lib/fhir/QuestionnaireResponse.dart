/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */
class QuestionnaireResponse {
  String resourceType;
  String id;
  Meta meta;
  String questionnaire;
  String status;
  Subject subject;
  List<QuestionnaireResponseItem> item;

  QuestionnaireResponse(
      {this.resourceType: "QuestionnaireResponse",
        this.id,
        this.meta,
        this.questionnaire,
        this.status,
        this.subject,
        this.item}) {
    if (this.item == null) {
      this.item = [];
    }
  }

  QuestionnaireResponse.fromJson(Map<String, dynamic> json) {
    resourceType = json['resourceType'];
    id = json['id'];
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    questionnaire = json['questionnaire'];
    status = json['status'];
    subject =
    json['subject'] != null ? new Subject.fromJson(json['subject']) : null;
    if (json['item'] != null) {
      item = new List<QuestionnaireResponseItem>();
      json['item'].forEach((v) {
        item.add(new QuestionnaireResponseItem.fromJson(v));
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
    data['questionnaire'] = this.questionnaire;
    data['status'] = this.status;
    if (this.subject != null) {
      data['subject'] = this.subject.toJson();
    }
    if (this.item != null) {
      data['item'] = this.item.map((v) => v.toJson()).toList();
    }
    return data;
  }

  void setAnswer(String linkId, Answer answer) {
    var responseItem = getResponseItem(linkId);
    if (responseItem != null) {
      responseItem.answer = [answer]; // single response
    } else {
      this.item.add(new QuestionnaireResponseItem(linkId: linkId, answer: [answer]));
    }
  }

  QuestionnaireResponseItem getResponseItem(String linkId) {
    for (QuestionnaireResponseItem responseItem in item) {
      if (responseItem.linkId == linkId) {
        return responseItem;
      }
    }
    return null;
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

class Subject {
  String reference;

  Subject({this.reference});

  Subject.fromJson(Map<String, dynamic> json) {
    reference = json['reference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reference'] = this.reference;
    return data;
  }
}

class QuestionnaireResponseItem {
  String linkId;
  List<Answer> answer;

  QuestionnaireResponseItem({this.linkId, this.answer});

  QuestionnaireResponseItem.fromJson(Map<String, dynamic> json) {
    linkId = json['linkId'];
    if (json['answer'] != null) {
      answer = new List<Answer>();
      json['answer'].forEach((v) {
        answer.add(new Answer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['linkId'] = this.linkId;
    if (this.answer != null) {
      data['answer'] = this.answer.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Answer {
  int valueInteger;

  Answer({this.valueInteger});

  Answer.fromJson(Map<String, dynamic> json) {
    valueInteger = json['valueInteger'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['valueInteger'] = this.valueInteger;
    return data;
  }
}
