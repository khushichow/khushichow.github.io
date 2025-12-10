import GooglePlacesAutocomplete from "react-google-places-autocomplete";

function Search() {
  return (
    <>
      {/* <GooglePlacesAutocomplete apiKey="AIzaSyCW3Zb5CjgV-nEv6-XEYsYNwBTgeSaJ-HA" /> */}
      <div className="pac-card" id="pac-card">
        <div>
          <div id="pac-container">
            <input id="pac-input" type="text" placeholder="Enter a location" />
          </div>
        </div>
        <div id="infowindow-content">
          <span id="place-name" className="title"></span>
          <br />
          <span id="place-address"></span>
        </div>
      </div>
    </>
  );
}

export default Search;
