class Statistics {
  D? d;

  Statistics({this.d});

  Statistics.fromJson(Map<String, dynamic> json) {
    d = json['d'] != null ? new D.fromJson(json['d']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.d != null) {
      data['d'] = this.d!.toJson();
    }
    return data;
  }
}

class D {
  List<Results>? results;

  D({this.results});

  D.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  Metadata? mMetadata;
  String? cDOCCREATEDDT;
  String? cDOCINVDATE;
  String? cDOCPROCTYPE;
  String? cDOCUUID;
  String? cDOCYEAR;
  String? cDOCYEARMONTH;
  String? cDPYBUYERUUID;
  String? cIPRPRODUUID;
  String? cIPRREFOCATCP;
  String? cIPRREFOPRDTY;
  String? cIPSALEMP;
  String? kCNTREVENUE;
  String? kCNINVQTY;
  String? kCNTVALINV;
   String? kKITMNETAMRC;
  String? kKITMGROSSAMT;
  String? tIPRPRODUUID;
  String? tDPYBUYERUUID;
   String? tIPRREFOCATCP;
  String? tIPSALEMP;

  Results(
      {this.mMetadata,
      this.cDOCCREATEDDT,
      this.cDOCINVDATE,
      this.cDOCPROCTYPE,
      this.cDOCUUID,
      this.cDOCYEAR,
      this.cDOCYEARMONTH,
      this.cIPRPRODUUID,
      this.cDPYBUYERUUID,
       this.cIPRREFOCATCP,
      this.cIPRREFOPRDTY,
      this.cIPSALEMP,
      this.kCNTREVENUE,
      this.kCNINVQTY,
      this.kKITMNETAMRC,
      this.kCNTVALINV,
      this.tIPRPRODUUID,
      this.kKITMGROSSAMT,
       this.tIPRREFOCATCP,
      this.tDPYBUYERUUID,
      this.tIPSALEMP});

  Results.fromJson(Map<String, dynamic> json) {
    mMetadata = json['__metadata'] != null
        ? new Metadata.fromJson(json['__metadata'])
        : null;
    cDOCCREATEDDT = json['CDOC_CREATED_DT'];
    cDOCINVDATE = json['CDOC_INV_DATE'];
    cDOCPROCTYPE = json['CDOC_PROC_TYPE'];
    cDOCUUID = json['CDOC_UUID'];
    cDOCYEAR = json['CDOC_YEAR'];
    cDOCYEARMONTH = json['CDOC_YEAR_MONTH'];
    cDPYBUYERUUID = json['CDPY_BUYER_UUID'];
    cIPRPRODUUID = json['CIPR_PROD_UUID'];
    cIPRREFOCATCP = json['CIPR_REFO_CATCP'];
    cIPRREFOPRDTY = json['CIPR_REFO_PRDTY'];
    cIPSALEMP = json['CIP_SAL_EMP'];
    kCNINVQTY = json['KCINV_QTY'];
    kCNTREVENUE = json['KCNT_REVENUE'];
      kKITMNETAMRC = json['KKITM_NET_AM_RC'];
    kCNTVALINV = json['KCNT_VAL_INV'];
    tIPRPRODUUID = json['TIPR_PROD_UUID'];
    kKITMGROSSAMT = json['KKITM_GROSS_AMT'];
    tDPYBUYERUUID = json['TDPY_BUYER_UUID'];
     tIPRREFOCATCP = json['TIPR_REFO_CATCP'];
    tIPSALEMP = json['TIP_SAL_EMP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mMetadata != null) {
      data['__metadata'] = this.mMetadata!.toJson();
    }
    data['CDOC_CREATED_DT'] = this.cDOCCREATEDDT;
    data['CDOC_INV_DATE'] = this.cDOCINVDATE;
    data['CDOC_PROC_TYPE'] = this.cDOCPROCTYPE;
    data['CDOC_UUID'] = this.cDOCUUID;
    data['CDOC_YEAR'] = this.cDOCYEAR;
    data['CDOC_YEAR_MONTH'] = this.cDOCYEARMONTH;
    data['CDPY_BUYER_UUID'] = this.cDPYBUYERUUID;
     data['CIPR_PROD_UUID'] = this.cIPRPRODUUID;
    data['CIPR_REFO_CATCP'] = this.cIPRREFOCATCP;
    data['CIPR_REFO_PRDTY'] = this.cIPRREFOPRDTY;
    data['CIP_SAL_EMP'] = this.cIPSALEMP;
    data['KCNT_REVENUE'] = this.kCNTREVENUE;
     data['KKITM_NET_AM_RC'] = this.kKITMNETAMRC;
     data['KCINV_QTY']= this.kCNINVQTY;
    data['KCNT_VAL_INV'] = this.kCNTVALINV;
    data['KKITM_GROSS_AMT'] = this.kKITMGROSSAMT;
    data['TIPR_PROD_UUID'] = this.tIPRPRODUUID;
    data['TIPR_REFO_CATCP'] = this.tIPRREFOCATCP;
    data['TDPY_BUYER_UUID'] = this.tDPYBUYERUUID;
    data['TIP_SAL_EMP'] = this.tIPSALEMP;
    return data;
  }
}

class Metadata {
  String? uri;
  String? type;

  Metadata({this.uri, this.type});

  Metadata.fromJson(Map<String, dynamic> json) {
    uri = json['uri'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uri'] = this.uri;
    data['type'] = this.type;
    return data;
  }
}

class BieuDo {
  Metadata? mMetadata;
  String? cDOCCREATEDDT;
  String? cDOCINVDATE;
  String? cDOCPROCTYPE;
  String? cDOCUUID;
  String? cDOCYEAR;
  String? cDOCYEARMONTH;
  String? cDPYBUYERUUID;
  String? cIPRPRODUUID;
  String? cIPRREFOCATCP;
  String? cIPRREFOPRDTY;
  String? cIPSALEMP;
  String? kCINVQTY;
  String? kCNTREVENUE;
  String? kCNTVALINV;
  String? kKITMGROSSAMT;
  String? kKITMNETAMRC;
  String? tDPYBUYERUUID;
  String? tIPRPRODUUID;
  String? tIPRREFOCATCP;
  String? tIPRREFOPRDTY;
  String? tIPSALEMP;

  BieuDo(
      {this.mMetadata,
      this.cDOCCREATEDDT,
      this.cDOCINVDATE,
      this.cDOCPROCTYPE,
      this.cDOCUUID,
      this.cDOCYEAR,
      this.cDOCYEARMONTH,
      this.cDPYBUYERUUID,
      this.cIPRPRODUUID,
      this.cIPRREFOCATCP,
      this.cIPRREFOPRDTY,
      this.cIPSALEMP,
      this.kCINVQTY,
      this.kCNTREVENUE,
      this.kCNTVALINV,
      this.kKITMGROSSAMT,
      this.kKITMNETAMRC,
      this.tDPYBUYERUUID,
      this.tIPRPRODUUID,
      this.tIPRREFOCATCP,
      this.tIPRREFOPRDTY,
      this.tIPSALEMP});

  BieuDo.fromJson(Map<String, dynamic> json) {
    mMetadata = json['__metadata'] != null
        ? new Metadata.fromJson(json['__metadata'])
        : null;
    cDOCCREATEDDT = json['CDOC_CREATED_DT'];
    cDOCINVDATE = json['CDOC_INV_DATE'];
    cDOCPROCTYPE = json['CDOC_PROC_TYPE'];
    cDOCUUID = json['CDOC_UUID'];
    cDOCYEAR = json['CDOC_YEAR'];
    cDOCYEARMONTH = json['CDOC_YEAR_MONTH'];
    cDPYBUYERUUID = json['CDPY_BUYER_UUID'];
    cIPRPRODUUID = json['CIPR_PROD_UUID'];
    cIPRREFOCATCP = json['CIPR_REFO_CATCP'];
    cIPRREFOPRDTY = json['CIPR_REFO_PRDTY'];
    cIPSALEMP = json['CIP_SAL_EMP'];
    kCINVQTY = json['KCINV_QTY'];
    kCNTREVENUE = json['KCNT_REVENUE'];
    kCNTVALINV = json['KCNT_VAL_INV'];
    kKITMGROSSAMT = json['KKITM_GROSS_AMT'];
    kKITMNETAMRC = json['KKITM_NET_AM_RC'];
    tDPYBUYERUUID = json['TDPY_BUYER_UUID'];
    tIPRPRODUUID = json['TIPR_PROD_UUID'];
    tIPRREFOCATCP = json['TIPR_REFO_CATCP'];
    tIPRREFOPRDTY = json['TIPR_REFO_PRDTY'];
    tIPSALEMP = json['TIP_SAL_EMP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mMetadata != null) {
      data['__metadata'] = this.mMetadata!.toJson();
    }
    data['CDOC_CREATED_DT'] = this.cDOCCREATEDDT;
    data['CDOC_INV_DATE'] = this.cDOCINVDATE;
    data['CDOC_PROC_TYPE'] = this.cDOCPROCTYPE;
    data['CDOC_UUID'] = this.cDOCUUID;
    data['CDOC_YEAR'] = this.cDOCYEAR;
    data['CDOC_YEAR_MONTH'] = this.cDOCYEARMONTH;
    data['CDPY_BUYER_UUID'] = this.cDPYBUYERUUID;
    data['CIPR_PROD_UUID'] = this.cIPRPRODUUID;
    data['CIPR_REFO_CATCP'] = this.cIPRREFOCATCP;
    data['CIPR_REFO_PRDTY'] = this.cIPRREFOPRDTY;
    data['CIP_SAL_EMP'] = this.cIPSALEMP;
    data['KCINV_QTY'] = this.kCINVQTY;
    data['KCNT_REVENUE'] = this.kCNTREVENUE;
    data['KCNT_VAL_INV'] = this.kCNTVALINV;
    data['KKITM_GROSS_AMT'] = this.kKITMGROSSAMT;
    data['KKITM_NET_AM_RC'] = this.kKITMNETAMRC;
    data['TDPY_BUYER_UUID'] = this.tDPYBUYERUUID;
    data['TIPR_PROD_UUID'] = this.tIPRPRODUUID;
    data['TIPR_REFO_CATCP'] = this.tIPRREFOCATCP;
    data['TIPR_REFO_PRDTY'] = this.tIPRREFOPRDTY;
    data['TIP_SAL_EMP'] = this.tIPSALEMP;
    return data;
  }
}
class Kehoach {
  Metadata? mMetadata;
  String? cEMPLOYEE;
  String? cPLANID;
  String? kCTARGETVALUE;
  String? tEMPLOYEE;

  Kehoach(
      {this.mMetadata,
      this.cEMPLOYEE,
      this.cPLANID,
      this.kCTARGETVALUE,
      this.tEMPLOYEE});

  Kehoach.fromJson(Map<String, dynamic> json) {
    mMetadata = json['__metadata'] != null
        ? new Metadata.fromJson(json['__metadata'])
        : null;
    cEMPLOYEE = json['CEMPLOYEE'];
    cPLANID = json['CPLAN_ID'];
    kCTARGETVALUE = json['KCTARGET_VALUE'];
    tEMPLOYEE = json['TEMPLOYEE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mMetadata != null) {
      data['__metadata'] = this.mMetadata!.toJson();
    }
    data['CEMPLOYEE'] = this.cEMPLOYEE;
    data['CPLAN_ID'] = this.cPLANID;
    data['KCTARGET_VALUE'] = this.kCTARGETVALUE;
    data['TEMPLOYEE'] = this.tEMPLOYEE;
    return data;
  }
}
