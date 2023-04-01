class Autogenerated {
  Envelope? envelope;

  Autogenerated({this.envelope});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    envelope = json['Envelope'] != null
        ? new Envelope.fromJson(json['Envelope'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.envelope != null) {
      data['Envelope'] = this.envelope!.toJson();
    }
    return data;
  }
}

class Envelope {
  String? header;
  Body? body;

  Envelope({this.header, this.body});

  Envelope.fromJson(Map<String, dynamic> json) {
    header = json['Header'];
    body = json['Body'] != null ? new Body.fromJson(json['Body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Header'] = this.header;
    if (this.body != null) {
      data['Body'] = this.body!.toJson();
    }
    return data;
  }
}

class Body {
  SalesPriceListFindByIDResponseSync? salesPriceListFindByIDResponseSync;

  Body({this.salesPriceListFindByIDResponseSync});

  Body.fromJson(Map<String, dynamic> json) {
    salesPriceListFindByIDResponseSync =
        json['SalesPriceListFindByIDResponse_sync'] != null
            ? new SalesPriceListFindByIDResponseSync.fromJson(
                json['SalesPriceListFindByIDResponse_sync'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.salesPriceListFindByIDResponseSync != null) {
      data['SalesPriceListFindByIDResponse_sync'] =
          this.salesPriceListFindByIDResponseSync!.toJson();
    }
    return data;
  }
}

class SalesPriceListFindByIDResponseSync {
  SalesPriceListFindByIDResponseMessage? salesPriceListFindByIDResponseMessage;

  SalesPriceListFindByIDResponseSync(
      {this.salesPriceListFindByIDResponseMessage});

  SalesPriceListFindByIDResponseSync.fromJson(Map<String, dynamic> json) {
    salesPriceListFindByIDResponseMessage =
        json['SalesPriceListFindByIDResponseMessage'] != null
            ? new SalesPriceListFindByIDResponseMessage.fromJson(
                json['SalesPriceListFindByIDResponseMessage'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.salesPriceListFindByIDResponseMessage != null) {
      data['SalesPriceListFindByIDResponseMessage'] =
          this.salesPriceListFindByIDResponseMessage!.toJson();
    }
    return data;
  }
}

class SalesPriceListFindByIDResponseMessage {
  String? iD;
  int? releaseStatusCode;
  String? releaseStatusName;
  int? approvalStatusCode;
  String? approvalStatusName;
  String? typeCode;
  String? typeName;
  String? currencyCode;
  String? currencyName;
  ValidityPeriod? validityPeriod;
  List<PriceSpecification>? priceSpecification;

  SalesPriceListFindByIDResponseMessage(
      {this.iD,
      this.releaseStatusCode,
      this.releaseStatusName,
      this.approvalStatusCode,
      this.approvalStatusName,
      this.typeCode,
      this.typeName,
      this.currencyCode,
      this.currencyName,
      this.validityPeriod,
      this.priceSpecification});

  SalesPriceListFindByIDResponseMessage.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    releaseStatusCode = json['ReleaseStatusCode'];
    releaseStatusName = json['ReleaseStatusName'];
    approvalStatusCode = json['ApprovalStatusCode'];
    approvalStatusName = json['ApprovalStatusName'];
    typeCode = json['TypeCode'];
    typeName = json['TypeName'];
    currencyCode = json['CurrencyCode'];
    currencyName = json['CurrencyName'];
    validityPeriod = json['ValidityPeriod'] != null
        ? new ValidityPeriod.fromJson(json['ValidityPeriod'])
        : null;
    if (json['PriceSpecification'] != null) {
      priceSpecification = <PriceSpecification>[];
      json['PriceSpecification'].forEach((v) {
        priceSpecification!.add(new PriceSpecification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['ReleaseStatusCode'] = this.releaseStatusCode;
    data['ReleaseStatusName'] = this.releaseStatusName;
    data['ApprovalStatusCode'] = this.approvalStatusCode;
    data['ApprovalStatusName'] = this.approvalStatusName;
    data['TypeCode'] = this.typeCode;
    data['TypeName'] = this.typeName;
    data['CurrencyCode'] = this.currencyCode;
    data['CurrencyName'] = this.currencyName;
    if (this.validityPeriod != null) {
      data['ValidityPeriod'] = this.validityPeriod!.toJson();
    }
    if (this.priceSpecification != null) {
      data['PriceSpecification'] =
          this.priceSpecification!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ValidityPeriod {
  String? intervalBoundaryTypeCode;
  StartTimePoint? startTimePoint;
  StartTimePoint? endTimePoint;

  ValidityPeriod(
      {this.intervalBoundaryTypeCode, this.startTimePoint, this.endTimePoint});

  ValidityPeriod.fromJson(Map<String, dynamic> json) {
    intervalBoundaryTypeCode = json['IntervalBoundaryTypeCode'];
    startTimePoint = json['StartTimePoint'] != null
        ? new StartTimePoint.fromJson(json['StartTimePoint'])
        : null;
    endTimePoint = json['EndTimePoint'] != null
        ? new StartTimePoint.fromJson(json['EndTimePoint'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IntervalBoundaryTypeCode'] = this.intervalBoundaryTypeCode;
    if (this.startTimePoint != null) {
      data['StartTimePoint'] = this.startTimePoint!.toJson();
    }
    if (this.endTimePoint != null) {
      data['EndTimePoint'] = this.endTimePoint!.toJson();
    }
    return data;
  }
}

class StartTimePoint {
  int? typeCode;
  String? date;

  StartTimePoint({this.typeCode, this.date});

  StartTimePoint.fromJson(Map<String, dynamic> json) {
    typeCode = json['TypeCode'];
    date = json['Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TypeCode'] = this.typeCode;
    data['Date'] = this.date;
    return data;
  }
}

class PriceSpecification {
  String? priceSpecificationElementTypeCode;
  String? priceSpecificationElementTypeName;
  int? priceSpecificationElementCategoryCode;
  String? priceSpecificationElementCategoryName;
  int? priceSpecificationElementPurposeCode;
  String? priceSpecificationElementPurposeName;
  int? consistencyStatusCode;
  String? consistencyStatusName;
  int? releaseStatusCode;
  String? releaseStatusName;
  int? baseQuantity;
  String? baseQuantityTypeCode;
  String? baseQuantityTypeCodeName;
  int? amount;
  List<PropertyValuation>? propertyValuation;

  PriceSpecification(
      {this.priceSpecificationElementTypeCode,
      this.priceSpecificationElementTypeName,
      this.priceSpecificationElementCategoryCode,
      this.priceSpecificationElementCategoryName,
      this.priceSpecificationElementPurposeCode,
      this.priceSpecificationElementPurposeName,
      this.consistencyStatusCode,
      this.consistencyStatusName,
      this.releaseStatusCode,
      this.releaseStatusName,
      this.baseQuantity,
      this.baseQuantityTypeCode,
      this.baseQuantityTypeCodeName,
      this.amount,
      this.propertyValuation});

  PriceSpecification.fromJson(Map<String, dynamic> json) {
    priceSpecificationElementTypeCode =
        json['PriceSpecificationElementTypeCode'];
    priceSpecificationElementTypeName =
        json['PriceSpecificationElementTypeName'];
    priceSpecificationElementCategoryCode =
        json['PriceSpecificationElementCategoryCode'];
    priceSpecificationElementCategoryName =
        json['PriceSpecificationElementCategoryName'];
    priceSpecificationElementPurposeCode =
        json['PriceSpecificationElementPurposeCode'];
    priceSpecificationElementPurposeName =
        json['PriceSpecificationElementPurposeName'];
    consistencyStatusCode = json['ConsistencyStatusCode'];
    consistencyStatusName = json['ConsistencyStatusName'];
    releaseStatusCode = json['ReleaseStatusCode'];
    releaseStatusName = json['ReleaseStatusName'];
    baseQuantity = json['BaseQuantity'];
    baseQuantityTypeCode = json['BaseQuantityTypeCode'];
    baseQuantityTypeCodeName = json['BaseQuantityTypeCodeName'];
    amount = json['Amount'];
    if (json['PropertyValuation'] != null) {
      propertyValuation = <PropertyValuation>[];
      json['PropertyValuation'].forEach((v) {
        propertyValuation!.add(new PropertyValuation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PriceSpecificationElementTypeCode'] =
        this.priceSpecificationElementTypeCode;
    data['PriceSpecificationElementTypeName'] =
        this.priceSpecificationElementTypeName;
    data['PriceSpecificationElementCategoryCode'] =
        this.priceSpecificationElementCategoryCode;
    data['PriceSpecificationElementCategoryName'] =
        this.priceSpecificationElementCategoryName;
    data['PriceSpecificationElementPurposeCode'] =
        this.priceSpecificationElementPurposeCode;
    data['PriceSpecificationElementPurposeName'] =
        this.priceSpecificationElementPurposeName;
    data['ConsistencyStatusCode'] = this.consistencyStatusCode;
    data['ConsistencyStatusName'] = this.consistencyStatusName;
    data['ReleaseStatusCode'] = this.releaseStatusCode;
    data['ReleaseStatusName'] = this.releaseStatusName;
    data['BaseQuantity'] = this.baseQuantity;
    data['BaseQuantityTypeCode'] = this.baseQuantityTypeCode;
    data['BaseQuantityTypeCodeName'] = this.baseQuantityTypeCodeName;
    data['Amount'] = this.amount;
    if (this.propertyValuation != null) {
      data['PropertyValuation'] =
          this.propertyValuation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PropertyValuation {
  PriceSpecificationElementPropertyValuation?
      priceSpecificationElementPropertyValuation;
  String? description;

  PropertyValuation(
      {this.priceSpecificationElementPropertyValuation, this.description});

  PropertyValuation.fromJson(Map<String, dynamic> json) {
    priceSpecificationElementPropertyValuation =
        json['PriceSpecificationElementPropertyValuation'] != null
            ? new PriceSpecificationElementPropertyValuation.fromJson(
                json['PriceSpecificationElementPropertyValuation'])
            : null;
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.priceSpecificationElementPropertyValuation != null) {
      data['PriceSpecificationElementPropertyValuation'] =
          this.priceSpecificationElementPropertyValuation!.toJson();
    }
    data['Description'] = this.description;
    return data;
  }
}

class PriceSpecificationElementPropertyValuation {
  bool? identifyingIndicator;
  PriceSpecificationElementPropertyReference?
      priceSpecificationElementPropertyReference;
  PriceSpecificationElementPropertyValue?
      priceSpecificationElementPropertyValue;

  PriceSpecificationElementPropertyValuation(
      {this.identifyingIndicator,
      this.priceSpecificationElementPropertyReference,
      this.priceSpecificationElementPropertyValue});

  PriceSpecificationElementPropertyValuation.fromJson(
      Map<String, dynamic> json) {
    identifyingIndicator = json['IdentifyingIndicator'];
    priceSpecificationElementPropertyReference =
        json['PriceSpecificationElementPropertyReference'] != null
            ? new PriceSpecificationElementPropertyReference.fromJson(
                json['PriceSpecificationElementPropertyReference'])
            : null;
    priceSpecificationElementPropertyValue =
        json['PriceSpecificationElementPropertyValue'] != null
            ? new PriceSpecificationElementPropertyValue.fromJson(
                json['PriceSpecificationElementPropertyValue'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IdentifyingIndicator'] = this.identifyingIndicator;
    if (this.priceSpecificationElementPropertyReference != null) {
      data['PriceSpecificationElementPropertyReference'] =
          this.priceSpecificationElementPropertyReference!.toJson();
    }
    if (this.priceSpecificationElementPropertyValue != null) {
      data['PriceSpecificationElementPropertyValue'] =
          this.priceSpecificationElementPropertyValue!.toJson();
    }
    return data;
  }
}

class PriceSpecificationElementPropertyReference {
  String? priceSpecificationElementPropertyID;
  int? priceSpecificationElementPropertyDefinitionClassCode;

  PriceSpecificationElementPropertyReference(
      {this.priceSpecificationElementPropertyID,
      this.priceSpecificationElementPropertyDefinitionClassCode});

  PriceSpecificationElementPropertyReference.fromJson(
      Map<String, dynamic> json) {
    priceSpecificationElementPropertyID =
        json['PriceSpecificationElementPropertyID'];
    priceSpecificationElementPropertyDefinitionClassCode =
        json['PriceSpecificationElementPropertyDefinitionClassCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PriceSpecificationElementPropertyID'] =
        this.priceSpecificationElementPropertyID;
    data['PriceSpecificationElementPropertyDefinitionClassCode'] =
        this.priceSpecificationElementPropertyDefinitionClassCode;
    return data;
  }
}

class PriceSpecificationElementPropertyValue {
  int? iD;
  int? code;

  PriceSpecificationElementPropertyValue({this.iD, this.code});

  PriceSpecificationElementPropertyValue.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Code'] = this.code;
    return data;
  }
}