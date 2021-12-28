import "html5-device-mockups/dist/device-mockups.min.css";
import { IPhoneSE } from "react-device-mockups";
import "./App.css";

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <IPhoneSE
          width={400}
          orientation="portrait"
          color="black"
          buttonProps={{
            onClick: () => alert("Home Button Clicked!"),
          }}
        >
          <iframe
            title="showcase"
            src="https://example.com"
            style={{
              width: "100%",
              height: "100%",
              margin: 0,
            }}
          />
        </IPhoneSE>
      </header>
    </div>
  );
}

export default App;
