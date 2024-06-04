import { WebView } from 'react-native-webview';
import Config from './config';

export default function App() {
  return (
    <WebView
      style={{ marginTop: 25 }}
      source={{ uri: Config.apiUrl }}
    />
  );
}
