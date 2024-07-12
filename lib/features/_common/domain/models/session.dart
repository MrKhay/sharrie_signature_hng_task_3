// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

@immutable

/// User Sesion
class Session {
  final String accessToken;
  final String refereshToken;
  const Session({
    required this.accessToken,
    required this.refereshToken,
  });

  Session copyWith({
    String? accessToken,
    String? refereshToken,
  }) {
    return Session(
      accessToken: accessToken ?? this.accessToken,
      refereshToken: refereshToken ?? this.refereshToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'access_token': accessToken,
      'referesh_token': refereshToken,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      accessToken: map['access_token'] as String,
      refereshToken: map['refresh_token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Session.fromJson(String source) =>
      Session.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Session(accessToken: $accessToken, refereshToken: $refereshToken)';

  @override
  bool operator ==(covariant Session other) {
    if (identical(this, other)) return true;

    return other.accessToken == accessToken &&
        other.refereshToken == refereshToken;
  }

  @override
  int get hashCode => accessToken.hashCode ^ refereshToken.hashCode;
}
