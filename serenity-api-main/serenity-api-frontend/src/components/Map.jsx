import {
  Alert,
  AlertIcon,
  Box,
  Button,
  ButtonGroup,
  Container,
  FormControl,
  FormLabel,
  Heading,
  HStack,
  IconButton,
  Input,
  Stack,
  Text,
  SkeletonText,
  useColorModeValue,
} from "@chakra-ui/react";
import {
  useJsApiLoader,
  GoogleMap,
  Autocomplete,
  DirectionsRenderer,
} from "@react-google-maps/api";
import { useRef, useState } from "react";

export default function Map(props) {
  const { isLoaded } = useJsApiLoader({
    googleMapsApiKey: "AIzaSyCW3Zb5CjgV-nEv6-XEYsYNwBTgeSaJ-HA",
    libraries: ["places"],
  });

  var x = document.getElementById("getLocation");

  function getLocation() {
    if (navigator.geolocation) {
      navigator.permissions
        .query({ name: "geolocation" })
        .then(function (permissionStatus) {
          if (permissionStatus.state == "granted") {
            setMapLoc();
          }
        });
    } else {
      x.innerHTML = "Geolocation is not supported by this browser.";
    }
  }

  const [map, setMap] = useState(/** @type google.maps.Map */ (null));
  const [directionsResponse, setDirectionsResponse] = useState(null);
  const [selectedOption, setSelectedOption] = useState(null);
  const [distance, setDistance] = useState("");
  const originRef = useRef();
  const destinationRef = useRef();

  if (!isLoaded) {
    return <SkeletonText />;
  }
  function setMapLoc() {
    const labels = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    let labelIndex = 0;
    navigator.geolocation.getCurrentPosition(function (position) {
      var location = new google.maps.LatLng(
        position.coords.latitude,
        position.coords.longitude
      );
      var map = new google.maps.Map(document.getElementById("map"), {
        zoom: 14,
        center: location,
      });
      var user = new google.maps.Marker({ position: location, map });

      var queenWest = new google.maps.Marker({
        position: { lat: 43.6436, lng: -79.4205 },
        map,
      });
      var queenWest2 = new google.maps.Marker({
        position: { lat: 43.6441, lng: -79.418 },
        map,
      });
      var whiteSquirrel = new google.maps.Marker({
        position: { lat: 43.643, lng: -79.4211 },
        map,
      });
      var workmanWay = new google.maps.Marker({
        position: { lat: 43.6436, lng: -79.4174 },
        map,
      });
      var college = new google.maps.Marker({
        position: { lat: 43.6585, lng: -79.3991 },
        map,
      });

      var queenWestInfo = new google.maps.InfoWindow({
        content: queenWestInfoText,
      });
      queenWest.addListener("click", function () {
        queenWestInfo.open(map, queenWest);
      });
      var userInfo = new google.maps.InfoWindow({ content: userInfoText });
      user.addListener("click", function () {
        userInfo.open(map, user);
      });
      var queenWest2Info = new google.maps.InfoWindow({
        content: queenWest2InfoText,
      });
      queenWest2.addListener("click", function () {
        queenWest2Info.open(map, queenWest2);
      });
      var whiteSquirrelInfo = new google.maps.InfoWindow({
        content: whiteSquirrelInfoText,
      });
      whiteSquirrel.addListener("click", function () {
        whiteSquirrelInfo.open(map, whiteSquirrel);
      });
      var workmanWayInfo = new google.maps.InfoWindow({
        content: workmanWayInfoText,
      });
      workmanWay.addListener("click", function () {
        workmanWayInfo.open(map, workmanWay);
      });
      var collegeInfo = new google.maps.InfoWindow({
        content: collegeInfoText,
      });
      college.addListener("click", function () {
        collegeInfo.open(map, college);
      });
    }, showError);
  }

  function showError(error) {
    switch (error.code) {
      case error.PERMISSION_DENIED:
        x.innerHTML = "User denied the request for Geolocation.";
        break;
      case error.POSITION_UNAVAILABLE:
        x.innerHTML = "Location information is unavailable.";
        break;
      case error.TIMEOUT:
        x.innerHTML = "The request to get user location timed out.";
        break;
      case error.UNKNOWN_ERROR:
        x.innerHTML = "An unknown error occurred.";
        break;
    }
  }

  const queenWestInfoText =
    '<div id="content">' +
    "<p>CAMH</p>" +
    "<p>1051 Queen Street West</p>" +
    "</div>";

  const queenWest2InfoText =
    '<div id="content">' +
    "<p>CAMH</p>" +
    "<p>1025 Queen Street West</p>" +
    "</div>";

  const whiteSquirrelInfoText =
    '<div id="content">' +
    "<p>CAMH</p>" +
    "<p>60 White Squirrel Way</p>" +
    "</div>";

  const workmanWayInfoText =
    '<div id="content">' + "<p>CAMH</p>" + "<p>80 Workman Way</p>" + "</div>";

  const collegeInfoText =
    '<div id="content">' +
    "<p>CAMH</p>" +
    "<p>250 College Street</p>" +
    "</div>";

  const userInfoText =
    '<div id="content">' + "<p>This is where you are located.</p>";
  ("</div>");

  return (
    <>
      <Box id="getLocation"></Box>
      <Box id="map"></Box>
    </>
  );
}
