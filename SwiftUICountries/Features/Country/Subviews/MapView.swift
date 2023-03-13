import SwiftUI
import MapKit

// MARK - SwiftUI

struct MapView: View {

    let latitude: Double
    let longitude: Double
    let inNavigationView: Bool

    var body: some View {
        if inNavigationView {
            // The map should fill the view
            _MapView(latitude: latitude, longitude: longitude)
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: .infinity)
                .ignoresSafeArea()
        } else {
            _MapView(latitude: latitude, longitude: longitude)
            #if os(tvOS)
                .focusable()
            #endif
        }
    }

}

// MARK: - Multiplatform

#if os(iOS) || os(tvOS)
typealias ViewRepresentable = UIViewRepresentable
#else
typealias ViewRepresentable = NSViewRepresentable
#endif

struct _MapView: ViewRepresentable {

    final class Coordinator {
        var firstUpdate: Bool = false
    }

    let latitude: Double
    let longitude: Double

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

#if os(iOS) || os(tvOS)
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {

        performFirstUpdateIfNeeded(uiView, context: context)

    }
#endif

#if os(macOS)
    func makeNSView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateNSView(_ nsView: MKMapView, context: Context) {

        performFirstUpdateIfNeeded(nsView, context: context)

    }
#endif

    private func performFirstUpdateIfNeeded(_ view: MKMapView, context: Context) {

        if !context.coordinator.firstUpdate {

            context.coordinator.firstUpdate = true

            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

            // Annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            view.addAnnotation(annotation)

            // Region
            let region = MKCoordinateRegion(center: coordinate,
                                            span: .init(latitudeDelta: 20, longitudeDelta: 20))
            view.setRegion(region, animated: true)
        }

    }

}
