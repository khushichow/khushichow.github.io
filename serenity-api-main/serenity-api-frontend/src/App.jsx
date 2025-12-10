import Container from "react-bootstrap/Container";
import Nav from "react-bootstrap/Nav";
import Navbar from "react-bootstrap/Navbar";
import APIview from "./components/APIview";
import Map from "./components/Map";
import Search from "./components/Search";

function App() {
  const IMAGES = {
    image: new URL("./assets/image.jpg", import.meta.url).href,
  };

  return (
    <>
      <section className="api-view">
        <div className="container">
          <APIview />
        </div>
      </section>
    </>
  );
}

export default App;
