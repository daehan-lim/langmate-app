class VworldDistrictDto {
  VworldDistrictDto({required this.response});

  final Response? response;

  factory VworldDistrictDto.fromJson(Map<String, dynamic> json) {
    return VworldDistrictDto(
      response:
          json["response"] == null ? null : Response.fromJson(json["response"]),
    );
  }

  Map<String, dynamic> toJson() => {"response": response?.toJson()};
}

class Response {
  Response({
    required this.service,
    required this.status,
    required this.record,
    required this.page,
    required this.result,
  });

  final Service? service;
  final String status;
  final Record? record;
  final Page? page;
  final Result? result;

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      service:
          json["service"] == null ? null : Service.fromJson(json["service"]),
      status: json["status"] ?? "",
      record: json["record"] == null ? null : Record.fromJson(json["record"]),
      page: json["page"] == null ? null : Page.fromJson(json["page"]),
      result: json["result"] == null ? null : Result.fromJson(json["result"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "service": service?.toJson(),
    "status": status,
    "record": record?.toJson(),
    "page": page?.toJson(),
    "result": result?.toJson(),
  };
}

class Page {
  Page({required this.total, required this.current, required this.size});

  final String total;
  final String current;
  final String size;

  factory Page.fromJson(Map<String, dynamic> json) {
    return Page(
      total: json["total"] ?? "",
      current: json["current"] ?? "",
      size: json["size"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "total": total,
    "current": current,
    "size": size,
  };
}

class Record {
  Record({required this.total, required this.current});

  final String total;
  final String current;

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(total: json["total"] ?? "", current: json["current"] ?? "");
  }

  Map<String, dynamic> toJson() => {"total": total, "current": current};
}

class Result {
  Result({required this.featureCollection});

  final FeatureCollection? featureCollection;

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      featureCollection:
          json["featureCollection"] == null
              ? null
              : FeatureCollection.fromJson(json["featureCollection"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "featureCollection": featureCollection?.toJson(),
  };
}

class FeatureCollection {
  FeatureCollection({
    required this.type,
    required this.bbox,
    required this.features,
  });

  final String type;
  final List<num> bbox;
  final List<Feature> features;

  factory FeatureCollection.fromJson(Map<String, dynamic> json) {
    return FeatureCollection(
      type: json["type"] ?? "",
      bbox:
          json["bbox"] == null
              ? []
              : List<num>.from(json["bbox"]!.map((x) => x)),
      features:
          json["features"] == null
              ? []
              : List<Feature>.from(
                json["features"]!.map((x) => Feature.fromJson(x)),
              ),
    );
  }

  Map<String, dynamic> toJson() => {
    "type": type,
    "bbox": bbox.map((x) => x).toList(),
    "features": features.map((x) => x.toJson()).toList(),
  };
}

class Feature {
  Feature({required this.type, required this.properties, required this.id});

  final String type;
  final Properties? properties;
  final String id;

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      type: json["type"] ?? "",
      properties:
          json["properties"] == null
              ? null
              : Properties.fromJson(json["properties"]),
      id: json["id"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "type": type,
    "properties": properties?.toJson(),
    "id": id,
  };
}

class Properties {
  Properties({
    required this.emdEngNm,
    required this.emdKorNm,
    required this.fullNm,
    required this.emdCd,
  });

  final String emdEngNm;
  final String emdKorNm;
  final String fullNm;
  final String emdCd;

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      emdEngNm: json["emd_eng_nm"] ?? "",
      emdKorNm: json["emd_kor_nm"] ?? "",
      fullNm: json["full_nm"] ?? "",
      emdCd: json["emd_cd"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "emd_eng_nm": emdEngNm,
    "emd_kor_nm": emdKorNm,
    "full_nm": fullNm,
    "emd_cd": emdCd,
  };
}

class Service {
  Service({
    required this.name,
    required this.version,
    required this.operation,
    required this.time,
  });

  final String name;
  final String version;
  final String operation;
  final String time;

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      name: json["name"] ?? "",
      version: json["version"] ?? "",
      operation: json["operation"] ?? "",
      time: json["time"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "version": version,
    "operation": operation,
    "time": time,
  };
}
