# Spotify Developer Setup Instructions

## Create Spotify App

1. **Visit Spotify Developer Dashboard**:
   - Go to https://developer.spotify.com/dashboard
   - Log in with your Spotify account (create one if needed)

2. **Create New App**:
   - Click "Create App"
   - Fill in the details:
     - **App name**: Mood Music App
     - **App description**: An app that detects emotions and plays matching music
     - **Website**: (optional) your website or GitHub repo
     - **Redirect URI**: `moodmusic://callback` (for mobile app)
   - Accept the Terms of Service
   - Click "Create"

3. **Get Your Credentials**:
   - From your app dashboard, copy:
     - **Client ID** 
     - **Client Secret** (click "Show client secret")

4. **Configure App Settings**:
   - In your app settings, add these redirect URIs:
     - `moodmusic://callback`
     - `com.yourpackage.moodmusicapp://callback`
   - Save the settings

## Add Credentials to App

After getting your credentials, update the `env.dart` file (next step) with:
- Your Client ID
- Your Client Secret

## API Scopes Used

The app requests these Spotify permissions:
- `playlist-read-public`: Read public playlists
- `playlist-read-private`: Read user's private playlists
- `streaming`: Play music through Spotify

## Testing

- Use Spotify Premium account for full playback features
- Free accounts can browse playlists but have limited playback

## Important Notes

- **Client Secret**: Keep this secret and never commit it to public repositories
- **Rate Limits**: Spotify API has rate limits (typically 100 requests per minute)
- **App Review**: For production apps serving many users, Spotify requires app review

## Troubleshooting

If you get authentication errors:
1. Check that Client ID/Secret are correct
2. Verify redirect URIs match exactly
3. Ensure Spotify app is installed on test device
4. Check that your Spotify account is not restricted