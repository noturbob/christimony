import 'package:christimony/core/network/endpoints.dart';
import 'package:christimony/data/api/christimony_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

/// HTTP-contract tests asserting the LITERAL outgoing request body for
/// endpoints on each side of the envelope hazard (see
/// `docs/mobile-v1-plan.md` §4.2): `profiles`/`prompts` wrap the payload
/// under a root key, everything else is sent flat. This is the
/// regression net that stops a future change to `ChristimonyApi.send`
/// from silently breaking the wrapping for one endpoint type.
///
/// Routes registered with the adapter are RELATIVE paths -- with a
/// `baseUrl` set, Dio's `RequestOptions.path` retains the relative path
/// passed to `dio.request()`, and `http_mock_adapter` matches against
/// that, not the fully-resolved absolute URL.
void main() {
  late Dio dio;
  late DioAdapter adapter;
  late ChristimonyApi api;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'));
    adapter = DioAdapter(dio: dio);
    api = ChristimonyApi(dio);
  });

  test('updateProfile wraps the body under a "profile" root key', () async {
    adapter.onPatch(
      '/profiles/1',
      (server) => server.reply(200, {'id': 1, 'name': 'Jane'}),
      data: {
        'profile': {'city': 'Chennai'},
      },
    );

    final result = await api.send<Map<String, dynamic>>(
      Api.updateProfile,
      pathArgs: {'id': 1},
      fields: {'city': 'Chennai'},
      decode: (json) => json! as Map<String, dynamic>,
    );

    expect(result['name'], 'Jane');
  });

  test('createProfile wraps the body under a "profile" root key', () async {
    adapter.onPost(
      '/profiles',
      (server) => server.reply(201, {'id': 5}),
      data: {
        'profile': {'name': 'Jane', 'profile_type': 'self'},
      },
    );

    final result = await api.send<int>(
      Api.createProfile,
      fields: {'name': 'Jane', 'profile_type': 'self'},
      decode: (json) => (json! as Map<String, dynamic>)['id'] as int,
    );

    expect(result, 5);
  });

  test('createPrompt wraps the body under a "prompt" root key', () async {
    adapter.onPost(
      '/profiles/3/prompts',
      (server) => server.reply(201, {'id': 9}),
      data: {
        'prompt': {'question': 'Q', 'answer': 'A'},
      },
    );

    final result = await api.send<int>(
      Api.createPrompt,
      pathArgs: {'pid': 3},
      fields: {'question': 'Q', 'answer': 'A'},
      decode: (json) => (json! as Map<String, dynamic>)['id'] as int,
    );

    expect(result, 9);
  });

  test('createVouch sends a FLAT body -- no wrapper key', () async {
    adapter.onPost(
      '/profiles/3/vouches',
      (server) => server.reply(201, {'id': 1}),
      data: {'voucher_name': 'Pastor Joe', 'voucher_role': 'pastor'},
    );

    final result = await api.send<int>(
      Api.createVouch,
      pathArgs: {'pid': 3},
      fields: {'voucher_name': 'Pastor Joe', 'voucher_role': 'pastor'},
      decode: (json) => (json! as Map<String, dynamic>)['id'] as int,
    );

    expect(result, 1);
  });

  test('sendMessage (createMessage) sends a FLAT body', () async {
    adapter.onPost(
      '/conversations/7/messages',
      (server) => server.reply(201, {'id': 2, 'body': 'hi'}),
      data: {'body': 'hi'},
    );

    final result = await api.send<Map<String, dynamic>>(
      Api.createMessage,
      pathArgs: {'cid': 7},
      fields: {'body': 'hi'},
      decode: (json) => json! as Map<String, dynamic>,
    );

    expect(result['body'], 'hi');
  });

  test('acceptIntroduction sends a FLAT {ward_profile_id} body', () async {
    adapter.onPost(
      '/introductions/4/accept',
      (server) => server.reply(200, {'id': 4, 'status': 'pending_b'}),
      data: {'ward_profile_id': 10},
    );

    final result = await api.send<Map<String, dynamic>>(
      Api.acceptIntroduction,
      pathArgs: {'id': 4},
      fields: {'ward_profile_id': 10},
      decode: (json) => json! as Map<String, dynamic>,
    );

    expect(result['status'], 'pending_b');
  });

  test('reorderPhotos sends a FLAT {order: [...]} body', () async {
    adapter.onPatch(
      '/profiles/3/photos/reorder',
      (server) => server.reply(200, <dynamic>[]),
      data: {
        'order': [3, 1, 2],
      },
    );

    final result = await api.send<List<dynamic>>(
      Api.reorderPhotos,
      pathArgs: {'pid': 3},
      fields: {
        'order': [3, 1, 2],
      },
      decode: (json) => json! as List<dynamic>,
    );

    expect(result, isEmpty);
  });

  test('createInterest sends a FLAT body with raw profile ids', () async {
    adapter.onPost(
      '/interests',
      (server) => server.reply(201, {
        'interest': {
          'id': 1,
          'sender_profile_id': 2,
          'receiver_profile_id': 3,
          'status': 'pending',
        },
        'match': null,
      }),
      data: {'sender_profile_id': 2, 'receiver_profile_id': 3},
    );

    final result = await api.send<Map<String, dynamic>>(
      Api.createInterest,
      fields: {'sender_profile_id': 2, 'receiver_profile_id': 3},
      decode: (json) => json! as Map<String, dynamic>,
    );

    expect(result['match'], isNull);
  });
}
