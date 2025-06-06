import 'dart:convert';
import 'package:ajoufinder/const/network.dart';
import 'package:ajoufinder/data/dto/board/board_statuses/board_statuses_response.dart';
import 'package:ajoufinder/data/dto/board/boards/boards_request.dart';
import 'package:ajoufinder/data/dto/board/boards/boards_response.dart';
import 'package:ajoufinder/data/dto/board/delete_board/delete_board_request.dart';
import 'package:ajoufinder/data/dto/board/delete_board/delete_board_response.dart';
import 'package:ajoufinder/data/dto/board/detailed_board/detailed_board_request.dart';
import 'package:ajoufinder/data/dto/board/detailed_board/detailed_board_response.dart';
import 'package:ajoufinder/data/dto/board/filter_boards/filter_board_response.dart';
import 'package:ajoufinder/data/dto/board/filter_boards/filter_boards_request.dart';
import 'package:ajoufinder/data/dto/board/patch_board/patch_board_request.dart';
import 'package:ajoufinder/data/dto/board/patch_board/patch_board_status_request.dart';
import 'package:ajoufinder/data/dto/board/patch_board/patch_board_status_response.dart';
import 'package:ajoufinder/data/dto/board/post_board/post_board_request.dart';
import 'package:ajoufinder/data/dto/board/post_board/post_board_response.dart';
import 'package:ajoufinder/data/dto/itemtype/itemtypes/itemtypes_response.dart';
import 'package:ajoufinder/domain/entities/board_item.dart';
import 'package:ajoufinder/domain/repository/board_repository.dart';
import 'package:http/http.dart' as http;

class BoardRepositoryImpl extends BoardRepository{
  final http.Client _client;

  BoardRepositoryImpl(this._client);

  @override
  Future<PostBoardResponse> postFoundBoard(PostBoardRequest request) async {
    final url = Uri.parse('$baseUrl/boards/found');
    try {
      final response = await _client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(request.toJson()),
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return PostBoardResponse.fromJson(responseBody);
      } else {
        print('습득 게시글 등록 API 오류: ${response.statusCode}, 본문: ${response.body}');
        throw Exception('습득 게시글 등록 실패 (서버 오류 ${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      print('습득 게시글 등록 API 네트워크 오류 발생: $e');
      throw Exception('습득 게시글 등록 중 네트워크 연결에 실패했습니다.');
    } catch (e) {
      print('습득 게시글 등록 API 응답 처리 중 예외 발생: $e');
      throw Exception('습득 게시글 등록 응답 처리 중 오류가 발생했습니다.');
    }
  }

  @override
  Future<PostBoardResponse> postLostBoard(PostBoardRequest request) async {
    final url = Uri.parse('$baseUrl/boards/lost');

    try {
      final response = await _client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(request.toJson()),
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return PostBoardResponse.fromJson(responseBody);
      } else {
        print('분실 게시글 등록 API 오류: ${response.statusCode}, 본문: ${response.body}');
        throw Exception('분실 게시글 등록 실패 (서버 오류 ${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      print('분실 게시글 등록 API 네트워크 오류 발생: $e');
      throw Exception('분실 게시글 등록 중 네트워크 연결에 실패했습니다.');
    } catch (e) {
      print('분실 게시글 등록 API 응답 처리 중 예외 발생: $e');
      throw Exception('분실 게시글 등록 응답 처리 중 오류가 발생했습니다.');
    }
  }

  @override
  Future<ItemtypesResponse> getAllItemTypes() async {
    final url = Uri.parse('$baseUrl/itemtypes');

    try {
      final response = await _client.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 이 API는 별도의 인증 헤더가 필요 없을 수 있습니다. (API 명세에 따라 확인)
          // 만약 JSESSIONID 쿠키 등이 필요하다면, http.Client가 자동으로 보내거나
          // 인터셉터 등을 통해 추가해야 합니다.
        },
      );

      final responseBody = json.decode(response.body);

      if  (response.statusCode >= 200 && response.statusCode < 300) {
        return ItemtypesResponse.fromJson(responseBody);
      } else {
        print('아이템 종류 API 오류: ${response.statusCode}, 본문: ${response.body}');
        // API 응답 구조에 따라 오류 메시지를 포함한 DTO를 반환하거나 예외를 발생시킬 수 있습니다.
        // 여기서는 예외를 발생시킵니다.
        throw Exception('아이템 종류 조회 실패 (서버 오류 ${response.statusCode})');
      } 
    } on http.ClientException catch (e) {
      print('아이템 종류 API 네트워크 오류 발생: $e');
      throw Exception('아이템 종류 조회 중 네트워크 연결에 실패했습니다.');
    } catch (e) {
      print('아이템 종류 API 응답 처리 중 예외 발생: $e');
      throw Exception('아이템 종류 응답 처리 중 오류가 발생했습니다.');
    }
  }

  @override
  Future<BoardStatusesResponse> getAllStatuses() async {
    await Future.delayed(Duration(milliseconds: 500));
    return BoardStatusesResponse(
      code: '200',
      message: '성공',
      result: ['ACTIVE', 'COMPLETED'],
      isSuccess: true,
    );
  }

  @override
  Future<List<BoardItem>> getAllBoardItemsByCategory(String category) async {
    await Future.delayed(Duration(milliseconds: 500));
    return [];
  }

  @override
  Future<BoardsResponse> getFoundBoards(BoardsRequest request) async {
    final Map<String, dynamic> queryParams = {};

    if (request.page != null) {
      queryParams['page'] = request.page.toString();
    }
    if (request.size != null) {
      queryParams['size'] = request.size.toString();
    }

    final url = Uri.parse('$baseUrl/boards/found').replace(
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    try {
      final response = await _client.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return BoardsResponse.fromJson(responseBody);
      } else {
        print('습득 게시글 목록 API 오류: ${response.statusCode}, 본문: ${response.body}');
        throw Exception('습득 게시글 목록 조회 실패 (서버 오류 ${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      print('습득 게시글 목록 API 네트워크 오류 발생: $e');
      throw Exception('습득 게시글 목록 조회 중 네트워크 연결에 실패했습니다.');
    } on FormatException catch (e) {
      print('습득 게시글 목록 API 응답 형식 오류: $e');
      throw Exception('습득 게시글 목록 응답 형식이 잘못되었습니다.');
    } catch (e) {
      print('습득 게시글 목록 API 응답 처리 중 예외 발생: $e');
      throw Exception('습득 게시글 목록 응답 처리 중 오류가 발생했습니다.');
    } 
  }
  
  @override
  Future<BoardsResponse> getLostBoards(BoardsRequest request) async {
    final Map<String, dynamic> queryParams = {};

    if (request.page != null) {
      queryParams['page'] = request.page.toString();
    }
    if (request.size != null) {
      queryParams['size'] = request.size.toString();
    }

    final url = Uri.parse('$baseUrl/boards/lost').replace(
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    try {
      final response = await _client.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return BoardsResponse.fromJson(responseBody);
      } else {
        print('습득 게시글 목록 API 오류: ${response.statusCode}, 본문: ${response.body}');
        throw Exception('습득 게시글 목록 조회 실패 (서버 오류 ${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      print('습득 게시글 목록 API 네트워크 오류 발생: $e');
      throw Exception('습득 게시글 목록 조회 중 네트워크 연결에 실패했습니다.');
    } on FormatException catch (e) {
      print('습득 게시글 목록 API 응답 형식 오류: $e');
      throw Exception('습득 게시글 목록 응답 형식이 잘못되었습니다.');
    } catch (e) {
      print('습득 게시글 목록 API 응답 처리 중 예외 발생: $e');
      throw Exception('습득 게시글 목록 응답 처리 중 오류가 발생했습니다.');
    }
  }
  
  @override
  Future<DetailedBoardResponse> getBoardById(DetailedBoardRequest request) async {
    final url = Uri.parse('$baseUrl/boards/${request.boardId}');
    
    try {
      final response = await _client.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return DetailedBoardResponse.fromJson(responseBody);
      } else {
        print('게시글 상세 조회 API 오류: ${response.statusCode}, 본문: ${response.body}');
        throw Exception('게시글 상세 조회 실패 (서버 오류 ${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      print('게시글 상세 조회 API 네트워크 오류 발생: $e');
      throw Exception('게시글 상세 조회 중 네트워크 연결에 실패했습니다.');
    } on FormatException catch (e) {
      print('게시글 상세 조회 API 응답 형식 오류: $e');
      throw Exception('게시글 상세 조회 응답 형식이 잘못되었습니다.');
    } catch (e) {
      print('게시글 상세 조회 API 응답 처리 중 예외 발생: $e');
      throw Exception('게시글 상세 조회 응답 처리 중 오류가 발생했습니다.');
    }
  }
  
  @override
  Future<BoardsResponse> getMyBoards(BoardsRequest request) async {
    final Map<String, dynamic> queryParams = {};

    if (request.page != null) {
      queryParams['page'] = request.page.toString();
    }
    if (request.size != null) {
      queryParams['size'] = request.size.toString();
    }

    final url = Uri.parse('$baseUrl/boards/user').replace(
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    try {
      final response = await _client.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return BoardsResponse.fromJson(responseBody);
      } else {
        print('내 게시글 목록 API 오류: ${response.statusCode}, 본문: ${response.body}');
        throw Exception('내 게시글 목록 조회 실패 (서버 오류 ${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      print('내 게시글 목록 API 네트워크 오류 발생: $e');
      throw Exception('내 게시글 목록 조회 중 네트워크 연결에 실패했습니다.');
    } on FormatException catch (e) {
      print('내 게시글 목록 API 응답 형식 오류: $e');
      throw Exception('내 게시글 목록 응답 형식이 잘못되었습니다.');
    } catch (e) {
      print('내 게시글 목록 API 응답 처리 중 예외 발생: $e');
      throw Exception('내 게시글 목록 응답 처리 중 오류가 발생했습니다.');
    }
  }

  @override
  Future<DeleteBoardResponse> deleteBoard(DeleteBoardRequest request) async {
    final url = Uri.parse('$baseUrl/boards/${request.boardId}');
    
    try {
      final response = await _client.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return DeleteBoardResponse.fromJson(responseBody);
      } else {
        print('게시글 삭제 API 오류: ${response.statusCode}, 본문: ${response.body}');
        throw Exception('게시글 삭제 실패 (서버 오류 ${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      print('게시글 삭제 API 네트워크 오류 발생: $e');
      throw Exception('게시글 삭제 중 네트워크 연결에 실패했습니다.');
    } on FormatException catch (e) {
      print('게시글 삭제 API 응답 형식 오류: $e');
      throw Exception('게시글 삭제 응답 형식이 잘못되었습니다.');
    } catch (e) {
      print('게시글 삭제 API 응답 처리 중 예외 발생: $e');
      throw Exception('게시글 삭제 응답 처리 중 오류가 발생했습니다.');
    }
  }

  @override
  Future<FilterBoardResponse> filterFoundBoards(FilterBoardsRequest request) async {
    final Map<String, dynamic> queryParams = {};

    if (request.page != null) {
      queryParams['page'] = request.page.toString();
    }
    if (request.size != null) {
      queryParams['size'] = request.size.toString();
    }
    if (request.status != null) {
      queryParams['status'] = request.status;
    }
    if (request.itemTypeId != null) {
      queryParams['item_type_id'] = request.itemTypeId.toString();
    }
    if (request.locationId != null) {
      queryParams['location_id'] = request.locationId.toString();
    }
    if (request.startDate != null) {
      queryParams['start_date'] = request.startDate!.toIso8601String();
    }
    if (request.endDate != null) {
      queryParams['end_date'] = request.endDate!.toIso8601String();
    }

    final url = Uri.parse('$baseUrl/boards/found/filter').replace(
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    try {
      final response = await _client.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final responseBody = json.decode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return FilterBoardResponse.fromJson(responseBody);
      } else {
        print('분실 게시글 필터링 API 오류: ${response.statusCode}, 본문: ${response.body}');
        throw Exception('분실 게시글 필터링 실패 (서버 오류 ${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      print('분실 게시글 필터링 API 네트워크 오류 발생: $e');
      throw Exception('분실 게시글 필터링 중 네트워크 연결에 실패했습니다.');
    } on FormatException catch (e) {
      print('분실 게시글 필터링 API 응답 형식 오류: $e');
      throw Exception('분실 게시글 필터링 응답 형식이 잘못되었습니다.');
    } catch (e) {
      print('분실 게시글 필터링 API 응답 처리 중 예외 발생: $e');
      throw Exception('분실 게시글 필터링 응답 처리 중 오류가 발생했습니다.');
    }
  }

  @override
  Future<FilterBoardResponse> filterLostBoards(FilterBoardsRequest request) async {
    final Map<String, dynamic> queryParams = {};

    if (request.page != null) {
      queryParams['page'] = request.page.toString();
    }
    if (request.size != null) {
      queryParams['size'] = request.size.toString();
    }
    if (request.status != null) {
      queryParams['status'] = request.status;
    }
    if (request.itemTypeId != null) {
      queryParams['item_type_id'] = request.itemTypeId.toString();
    }
    if (request.locationId != null) {
      queryParams['location_id'] = request.locationId.toString();
    }
    if (request.startDate != null) {
      queryParams['start_date'] = request.startDate!.toIso8601String();
    }
    if (request.endDate != null) {
      queryParams['end_date'] = request.endDate!.toIso8601String();
    }

    final url = Uri.parse('$baseUrl/boards/lost/filter').replace(
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    try {
      final response = await _client.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final responseBody = json.decode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return FilterBoardResponse.fromJson(responseBody);
      } else {
        print('분실 게시글 필터링 API 오류: ${response.statusCode}, 본문: ${response.body}');
        throw Exception('분실 게시글 필터링 실패 (서버 오류 ${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      print('분실 게시글 필터링 API 네트워크 오류 발생: $e');
      throw Exception('분실 게시글 필터링 중 네트워크 연결에 실패했습니다.');
    } on FormatException catch (e) {
      print('분실 게시글 필터링 API 응답 형식 오류: $e');
      throw Exception('분실 게시글 필터링 응답 형식이 잘못되었습니다.');
    } catch (e) {
      print('분실 게시글 필터링 API 응답 처리 중 예외 발생: $e');
      throw Exception('분실 게시글 필터링 응답 처리 중 오류가 발생했습니다.');
    }
  }

  @override
  Future<PatchBoardStatusResponse> patchBoardAcitve(PatchBoardStatusRequest request) async {
    final url = Uri.parse('$baseUrl/boards/${request.boardId}/active');

    try {
      final response = await _client.patch(
        url,
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
        }
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return PatchBoardStatusResponse.fromJson(responseBody);
      } else {
        print('게시글 Activation API 오류 : ${response.statusCode} 본문 : ${response.body}');
        throw Exception('게시글 Acitvation 실패 (서버 오류 ${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      print('게시글 Activation API 네트워크 오류 발생: $e');
      throw Exception('게시글 Activation 중 네트워크 연결에 실패했습니다.');
    } on FormatException catch (e) {
      print('게시글 Activation API 응답 형식 오류: $e');
      throw Exception('게시글 Activation 응답 형식이 잘못되었습니다.');
    } catch (e) {
      print('게시글 Activation API 응답 처리 중 예외 발생: $e');
      throw Exception('게시글 Activation 응답 처리 중 오류가 발생했습니다.');
    }
  }

  @override
  Future<PatchBoardStatusResponse> patchBoardCompleted(PatchBoardStatusRequest request) async {
    final url = Uri.parse('$baseUrl/boards/${request.boardId}/completed');
    
    try {
      final response = await _client.patch(
        url,
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
        }
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return PatchBoardStatusResponse.fromJson(responseBody);
      } else {
        print('게시글 Completion API 오류 : ${response.statusCode} 본문 : ${response.body}');
        throw Exception('게시글 Completion 실패 (서버 오류 ${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      print('게시글 Completion API 네트워크 오류 발생: $e');
      throw Exception('게시글 Completion 중 네트워크 연결에 실패했습니다.');
    } on FormatException catch (e) {
      print('게시글 Completion API 응답 형식 오류: $e');
      throw Exception('게시글 Completion 응답 형식이 잘못되었습니다.');
    } catch (e) {
      print('게시글 Completion API 응답 처리 중 예외 발생: $e');
      throw Exception('게시글 Completion 응답 처리 중 오류가 발생했습니다.');
    }
  }

  @override
  Future<PatchBoardStatusResponse> patchBoard(PatchBoardRequest request) async {
    final url = Uri.parse('$baseUrl/boards/${request.boardId}');

    /**try {
      final response = await _client.patch(
        url,
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
        }
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {

      }
    }*/
    throw UnimplementedError();
  }

  
}