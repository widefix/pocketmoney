import { WebView } from 'react-native-webview';

export default function App() {
  return (
    <WebView
      source={{ uri: 'https://money.dokku.widefix.com/' }} 
    />
  );
}
