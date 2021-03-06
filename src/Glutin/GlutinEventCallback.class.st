Class {
	#name : #GlutinEventCallback,
	#superclass : #FFICallback,
	#category : #'Glutin-Event fetcher'
}

{ #category : #resources }
GlutinEventCallback class >> ffiLibrary [

	^ GlutinSameThreadLibrary
]

{ #category : #'callback spec' }
GlutinEventCallback class >> fnSpec [
	^ #(GlutinControlFlow ( void* event ))
]

{ #category : #'callback spec' }
GlutinEventCallback class >> on: aBlock [
	^ self 
		newCallbackWithSignature: self fnSpec 
		block: aBlock
]

{ #category : #resources }
GlutinEventCallback >> calloutAPIClass [

	^ ThreadedFFIMigration threadedFFIAvailable
		ifTrue: [ TFCalloutAPI ]
		ifFalse: [ super calloutAPIClass ]
]

{ #category : #resources }
GlutinEventCallback >> ffiLibrary [

	^ self class ffiLibrary
]
