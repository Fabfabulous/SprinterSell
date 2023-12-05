// app/javascript/controllers/map_controller.js
import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl' // Don't forget this!

export default class extends Controller {
  static targets= ["input", "form", "list", "map"]
  static values = {
    apiKey: String,
    markers: Array,
    nextMeeting: Array
  }
  connect() {
    this.markers = []
    mapboxgl.accessToken = this.apiKeyValue
    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: "mapbox://styles/mapbox/streets-v10"
    })

    this.#createMarkersToMap()

    /* START - Locate the user */
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition((position) => {
        const latitude  = position.coords.latitude;
        const longitude = position.coords.longitude;
        const start     = [longitude, latitude];

        new mapboxgl.Marker({ color: 'green' }) // change color marker
          .setLngLat([longitude, latitude])
          .addTo(this.map);

        const coordinates = [[this.nextMeetingValue[0].lng, this.nextMeetingValue[0].lat]]

        coordinates.unshift(start);
        console.log(this.nextMeetingValue)
        console.log(coordinates);

        fetch(
          `https://api.mapbox.com/directions/v5/mapbox/driving-traffic/${coordinates.join(';')}?geometries=geojson&access_token=${mapboxgl.accessToken}`,
          { method: 'GET' }
        )
          .then((response) => response.json())
          .then((data) => {
            const routes = data.routes[0];
            const route = routes.geometry.coordinates;
            const geojson = {
              type: 'Feature',
              properties: {},
              geometry: {
                type: 'LineString',
                coordinates: route
              }
            };

            this.map.addLayer({
              id: 'route',
              type: 'line',
              source: {
                type: 'geojson',
                data: geojson
              },
              layout: {
                'line-join': 'round',
                'line-cap': 'round'
              },
              paint: {
                'line-color': '#3887be',
                'line-width': 5,
                'line-opacity': 0.75
              }
            });
          })
      });
    } else {
      console.log("La géolocalisation n'est pas supportée par ce navigateur");
    }
    this.#fitMapToMarkers()
  }

  #createMarkersToMap() {
    this.#addMarkersToMap(this.markersValue, this.markersProspectValue)
  }

  #addMarkersToMap(markers, propectMarkers) {
    this.markers.forEach((m) => {
      m.remove()
    })
    markers.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)
      const markerHTML = new mapboxgl.Marker({ color: 'blue' })
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)
      this.markers.push(markerHTML)
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }


  update() {
    const url = `${this.formTarget.action}?query=${this.inputTarget.value}`
    console.log(url)
    fetch(url, {
        headers:{
          "Accept": "application/json"
        }
      })
      .then(response => response.json())
      .then((data) => {
        console.log(data);
        this.listTarget.innerHTML = data.companies_html
        this.#addMarkersToMap(data.markers, [])
      })
  }

}
