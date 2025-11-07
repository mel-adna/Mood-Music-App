import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../models/emotion_model.dart';
import '../config/environment.dart';

/// Service for integrating with Spotify Web API
class SpotifyService {
  static SpotifyService? _instance;
  String? _accessToken;
  DateTime? _tokenExpiry;

  /// Singleton instance
  static SpotifyService get instance {
    _instance ??= SpotifyService._internal();
    return _instance!;
  }

  SpotifyService._internal();

  /// Factory constructor
  factory SpotifyService() {
    return instance;
  }

  /// Initialize Spotify service and get access token
  Future<void> initialize() async {
    try {
      await _getAccessToken();
      if (kDebugMode) {
        print('SpotifyService initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize SpotifyService: $e');
      }
      // Continue without throwing - app can work without Spotify integration
    }
  }

  /// Get access token using Client Credentials flow
  Future<void> _getAccessToken() async {
    try {
      final credentials = base64Encode(
        utf8.encode(
          '${Environment.spotifyClientId}:${Environment.spotifyClientSecret}',
        ),
      );

      final response = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Authorization': 'Basic $credentials',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'grant_type=client_credentials',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _accessToken = data['access_token'];
        final expiresIn = data['expires_in'] as int;
        _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));
      } else {
        throw Exception('Failed to get access token: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting Spotify access token: $e');
    }
  }

  /// Check if access token is valid
  bool _isTokenValid() {
    return _accessToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!);
  }

  /// Ensure we have a valid access token
  Future<void> _ensureValidToken() async {
    if (!_isTokenValid()) {
      await _getAccessToken();
    }
  }

  /// Play Spotify playlist based on emotion
  Future<bool> playPlaylistForEmotion(EmotionType emotion) async {
    try {
      // Open Spotify web player with playlist URL
      final url = emotion.spotifyWebUrl;
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      } else {
        if (kDebugMode) {
          print('Could not launch Spotify URL: $url');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error launching Spotify playlist: $e');
      }
      return false;
    }
  }

  /// Get playlist information for an emotion
  Future<Map<String, dynamic>?> getPlaylistInfo(EmotionType emotion) async {
    if (!_isTokenValid()) {
      try {
        await _ensureValidToken();
      } catch (e) {
        return _getMockPlaylistInfo(emotion);
      }
    }

    try {
      // Extract playlist ID from URI
      final uri = emotion.spotifyPlaylistUri;
      final playlistId = uri.split(':').last;

      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/playlists/$playlistId'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'name': data['name'],
          'description': data['description'],
          'image': data['images']?.isNotEmpty == true
              ? data['images'][0]['url']
              : null,
          'tracks_total': data['tracks']['total'],
          'external_url': data['external_urls']['spotify'],
        };
      } else {
        return _getMockPlaylistInfo(emotion);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting playlist info: $e');
      }
      return _getMockPlaylistInfo(emotion);
    }
  }

  /// Get mock playlist info when API is unavailable
  Map<String, dynamic> _getMockPlaylistInfo(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.happy:
        return {
          'name': 'Happy Vibes',
          'description': 'Feel good music to brighten your day',
          'image': null,
          'tracks_total': 50,
          'external_url': emotion.spotifyWebUrl,
        };
      case EmotionType.sad:
        return {
          'name': 'Melancholy Moments',
          'description': 'Emotional songs for when you need to feel',
          'image': null,
          'tracks_total': 45,
          'external_url': emotion.spotifyWebUrl,
        };
      case EmotionType.angry:
        return {
          'name': 'Intense Energy',
          'description': 'Powerful music to channel your emotions',
          'image': null,
          'tracks_total': 40,
          'external_url': emotion.spotifyWebUrl,
        };
      case EmotionType.surprised:
        return {
          'name': 'Chill Vibes',
          'description': 'Relaxing tunes for unexpected moments',
          'image': null,
          'tracks_total': 35,
          'external_url': emotion.spotifyWebUrl,
        };
      case EmotionType.fearful:
        return {
          'name': 'Dark & Stormy',
          'description': 'Atmospheric music for intense feelings',
          'image': null,
          'tracks_total': 30,
          'external_url': emotion.spotifyWebUrl,
        };
      case EmotionType.disgusted:
        return {
          'name': 'Alternative Edge',
          'description': 'Music with attitude and edge',
          'image': null,
          'tracks_total': 38,
          'external_url': emotion.spotifyWebUrl,
        };
      case EmotionType.neutral:
        return {
          'name': 'Balanced Mix',
          'description': 'A perfect blend for any mood',
          'image': null,
          'tracks_total': 60,
          'external_url': emotion.spotifyWebUrl,
        };
    }
  }

  /// Search for playlists by mood/emotion
  Future<List<Map<String, dynamic>>> searchPlaylistsByMood(String mood) async {
    if (!_isTokenValid()) {
      try {
        await _ensureValidToken();
      } catch (e) {
        return [];
      }
    }

    try {
      final query = Uri.encodeComponent('$mood mood');
      final response = await http.get(
        Uri.parse(
          'https://api.spotify.com/v1/search?q=$query&type=playlist&limit=10',
        ),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final playlists = data['playlists']['items'] as List;
        return playlists
            .map(
              (playlist) => {
                'id': playlist['id'],
                'name': playlist['name'],
                'description': playlist['description'] ?? '',
                'image': playlist['images']?.isNotEmpty == true
                    ? playlist['images'][0]['url']
                    : null,
                'external_url': playlist['external_urls']['spotify'],
              },
            )
            .toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error searching playlists: $e');
      }
    }
    return [];
  }

  /// Open Spotify app or web player
  Future<bool> openSpotify() async {
    try {
      // Try to open Spotify app first
      final spotifyAppUri = Uri.parse('spotify://');
      if (await canLaunchUrl(spotifyAppUri)) {
        await launchUrl(spotifyAppUri);
        return true;
      }

      // Fallback to web player
      final webUri = Uri.parse('https://open.spotify.com');
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error opening Spotify: $e');
      }
      return false;
    }
  }

  /// Check if Spotify is available
  Future<bool> isSpotifyAvailable() async {
    try {
      final uri = Uri.parse('https://open.spotify.com');
      return await canLaunchUrl(uri);
    } catch (e) {
      return false;
    }
  }

  /// Get current access token (for debugging)
  String? get accessToken => _accessToken;

  /// Check if service is authenticated
  bool get isAuthenticated => _isTokenValid();
}
