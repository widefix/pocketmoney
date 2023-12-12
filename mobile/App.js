import { WebView } from 'react-native-webview';
import Config from './config';

export default function App() {
  return (
    <WebView
      source={{ uri: Config.apiUrl }} 
    />
  );
}
