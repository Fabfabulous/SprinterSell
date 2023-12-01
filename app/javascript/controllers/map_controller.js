// app/javascript/controllers/map_controller.js
import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl' // Don't forget this!

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }
  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })

    this.#addMarkersToMap()

    /* START - Locate the user */
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition((position) => {
        const latitude = position.coords.latitude;
        const longitude = position.coords.longitude;

        const userMarker = new mapboxgl.Marker({ color: 'blue' }) // change color marker
          .setLngLat([longitude, latitude])
          .addTo(this.map);

        const markersCoordinates = this.markersValue.map((marker) => {
          return `${marker.lat},${marker.lng}`
        })

        console.log(markersCoordinates);

        const coordinates = [[`${latitude},${longitude}`], markersCoordinates].flat()

        fetch(`https://api.mapbox.com/optimized-trips/v1/mapbox/driving/${coordinates.join(';')}?access_token=${this.apiKeyValue}&geometries=geojson`, {
          method: "GET",
          headers: {"Accept": "application/json"}
        })
          .then(response => response.json())
          .then(data => console.log(data));



      });
    } else {
      console.log("La géolocalisation n'est pas supportée par ce navigateur");
    }
    this.#fitMapToMarkers()
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }
}
