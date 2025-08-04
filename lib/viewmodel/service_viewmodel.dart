// lib/viewmodel/service_viewmodel.dart

import 'package:flutter_bengkelin_owner/config/model/resp.dart';
import 'package:flutter_bengkelin_owner/config/network.dart';
import 'package:flutter_bengkelin_owner/config/endpoint.dart';

class ServiceViewmodel {
  // Fungsi untuk mengambil data kecamatan
  Future<Resp> kecamatan() async {
    try {
      final responseData = await Network.getApi(Endpoint.kecamatanUrl);

      // Cek apakah respons dari API berupa Map
      if (responseData is Map<String, dynamic>) {
        return Resp.fromJson(responseData);
      } else {
        // Jika format respons tidak valid, kembalikan Resp dengan pesan error
        return Resp(
          code: 500,
          message: 'Respons API tidak valid untuk data kecamatan.',
        );
      }
    } catch (e) {
      return Resp(
        code: 500,
        message: 'Terjadi kesalahan saat mengambil data kecamatan: $e',
      );
    }
  }

  // Fungsi untuk mengambil data kelurahan berdasarkan kecamatanId
  Future<Resp> kelurahan({required int kecamatanId}) async {
    try {
      final responseData = await Network.getApi(
        '${Endpoint.kelurahanUrl}/$kecamatanId',
      );

      // Cek apakah respons dari API berupa Map
      if (responseData is Map<String, dynamic>) {
        return Resp.fromJson(responseData);
      } else {
        return Resp(
          code: 500,
          message: 'Respons API tidak valid untuk data kelurahan.',
        );
      }
    } catch (e) {
      return Resp(
        code: 500,
        message: 'Terjadi kesalahan saat mengambil data kelurahan: $e',
      );
    }
  }
}
