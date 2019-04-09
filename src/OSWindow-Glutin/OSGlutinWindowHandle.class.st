Class {
	#name : #OSGlutinWindowHandle,
	#superclass : #OSWindowHandle,
	#instVars : [
		'handle',
		'cursorPosition'
	],
	#category : #'OSWindow-Glutin'
}

{ #category : #'instance creation' }
OSGlutinWindowHandle class >> newWithHandle: aHandle [
	^ self basicNew initWithHandle: aHandle
]

{ #category : #accessing }
OSGlutinWindowHandle >> bounds: newBounds [
	self
		position: newBounds origin;
		extent: newBounds extent
]

{ #category : #accessing }
OSGlutinWindowHandle >> canvasExtent [
	^ self handle framebufferExtent
]

{ #category : #'events-processing' }
OSGlutinWindowHandle >> convertModifiers: theGlutinModifiers for: osWindowModifiers [
	osWindowModifiers
		leftShift: theGlutinModifiers shift; rightShift: theGlutinModifiers shift;
		leftCtrl: theGlutinModifiers ctrl; rightCtrl: theGlutinModifiers ctrl;
		leftAlt: theGlutinModifiers alt; rightAlt: theGlutinModifiers alt;
		leftCmd: theGlutinModifiers logo; rightCmd: theGlutinModifiers logo
]

{ #category : #deleting }
OSGlutinWindowHandle >> destroy [
	self handle destroy.
	handle := nil
]

{ #category : #accessing }
OSGlutinWindowHandle >> extent [
	^ self handle innerExtent
]

{ #category : #accessing }
OSGlutinWindowHandle >> extent: newExtent [
	self winitWindow innerExtent: newExtent
]

{ #category : #accessing }
OSGlutinWindowHandle >> handle [
	<return: #GlutinWindowedContext>

	^ handle
]

{ #category : #initialize }
OSGlutinWindowHandle >> initWithHandle: aHandle [
	"aHandle is GlutinWindowedContext"

	handle := aHandle
]

{ #category : #'text input' }
OSGlutinWindowHandle >> isTextInputActive [
	^ true
]

{ #category : #testing }
OSGlutinWindowHandle >> isValid [
	^ handle isNotNil and: [ handle isValid ]
]

{ #category : #factory }
OSGlutinWindowHandle >> newOpenGLRenderer [
	^ renderer := OSGlutinRenderer new 
		window: self;
		yourself
]

{ #category : #accessing }
OSGlutinWindowHandle >> platformSpecificHandle [
	^ nil
]

{ #category : #'events-processing' }
OSGlutinWindowHandle >> pollEvents [
	self isValid
		ifFalse: [ ^ self ].

	handle pollEvents: [ :aWinitEvent | aWinitEvent mapped accept: self ]
]

{ #category : #accessing }
OSGlutinWindowHandle >> position [
	^ self handle position
]

{ #category : #accessing }
OSGlutinWindowHandle >> position: newPosition [
	self handle position: newPosition
]

{ #category : #accessing }
OSGlutinWindowHandle >> show [
	
]

{ #category : #'text input' }
OSGlutinWindowHandle >> startTextInput [
	
]

{ #category : #'text input' }
OSGlutinWindowHandle >> stopTextInput [
	
]

{ #category : #accessing }
OSGlutinWindowHandle >> title [
	^ self winitWindow title
]

{ #category : #accessing }
OSGlutinWindowHandle >> title: aTitle [
	self winitWindow title: aTitle
]

{ #category : #'events-processing' }
OSGlutinWindowHandle >> visitCharacterReceivedEvent: anEvent [
	| aText osEvent |
	
	aText := ((#[ 0 0 0 0 ]
		at: 1 put: anEvent byte_1;
		at: 2 put: anEvent byte_2;
		at: 3 put: anEvent byte_3;
		at: 4 put: anEvent byte_4;
		yourself) first: anEvent length) utf8Decoded.
		
	osEvent := OSTextInputEvent for: osWindow.
	osEvent
		text: aText;
		position: cursorPosition.

	^ osEvent deliver
]

{ #category : #'events-processing' }
OSGlutinWindowHandle >> visitCursorMovedEvent: aCursorMovedEvent [
	| aNewCursorPosition aDelta osEvent |
	
	aNewCursorPosition := aCursorMovedEvent x @ aCursorMovedEvent y.
	aDelta := cursorPosition
		ifNil: [ 0@0 ]
		ifNotNil: [ aNewCursorPosition - cursorPosition ].

	osEvent := OSMouseMoveEvent for: osWindow.
	osEvent
		position: aNewCursorPosition;
		delta: aDelta.

	cursorPosition := aNewCursorPosition.

	self convertModifiers: aCursorMovedEvent modifiers for: osEvent modifiers.
	^ osEvent deliver
]

{ #category : #'events-processing' }
OSGlutinWindowHandle >> visitKeyboardInputEvent: anEvent [
	| osEvent aState |

	"anEvent logCr."

	anEvent has_virtual_keycode
		ifFalse: [ ^ self ].

	cursorPosition
		ifNil: [ ^ self ].

	aState := anEvent state.
	
	osEvent := aState = GlutinEventInputElementState Pressed
		ifTrue: [ OSKeyDownEvent for: osWindow ]
		ifFalse: [ OSKeyUpEvent for: osWindow ].

	osEvent scanCode: anEvent scan_code.

	self convertModifiers: anEvent modifiers for: osEvent modifiers.
	
	
	
	"^ osEvent deliver."
]

{ #category : #'events-processing' }
OSGlutinWindowHandle >> visitMouseInputEvent: aMouseInputEvent [
	| aButton aState osEvent |
	
	"cursor position is unknown, we can not properly handle mouse input event, therefore ignore it"
	cursorPosition
		ifNil: [ ^ self ].
	
	aButton := aMouseInputEvent button.
	aState := aMouseInputEvent state.
	
	osEvent := aState = GlutinEventInputElementState Pressed
		ifTrue: [ OSMouseButtonPressEvent for: osWindow ]
		ifFalse: [ OSMouseButtonReleaseEvent for: osWindow ].
	
	osEvent button: (aButton button_type = GlutinEventMouseButtonType Left
		ifTrue: [ 1 ]
		ifFalse: [ aButton button_type = GlutinEventMouseButtonType Middle
			ifTrue: [ 2 ]
			ifFalse: [ aButton button_type = GlutinEventMouseButtonType Right
				ifTrue: [ 3 ]
				ifFalse: [ aButton button_code ] ] ]).
	
	osEvent position: cursorPosition.
		
	self convertModifiers: aMouseInputEvent modifiers for: osEvent modifiers.

	^ osEvent deliver.
]

{ #category : #'events-processing' }
OSGlutinWindowHandle >> visitMouseWheelEvent: aMouseWheelEvent [
	| osEvent aDelta |

	cursorPosition
		ifNil: [ ^ self ].
		
	aDelta := aMouseWheelEvent delta.

	osEvent := OSMouseWheelEvent for: osWindow.
	osEvent
		position: cursorPosition;
		scrollHorizontal: (aDelta x);
		scrollVertical: (aDelta y).
			
	self convertModifiers: aMouseWheelEvent modifiers for: osEvent modifiers.
	^ osEvent deliver
]

{ #category : #'events-processing' }
OSGlutinWindowHandle >> visitTouchEvent: aTouchEvent [
	
]

{ #category : #'events-processing' }
OSGlutinWindowHandle >> visitUnknownEvent: anUnknownEvent [
	
]

{ #category : #'events-processing' }
OSGlutinWindowHandle >> visitWindowCloseRequest: aWindowCloseRequest [
	^ (OSWindowCloseEvent for: osWindow) deliver
]

{ #category : #'events-processing' }
OSGlutinWindowHandle >> visitWindowDestroyed: aWindowDestroyedEvent [
	
]

{ #category : #'events-processing' }
OSGlutinWindowHandle >> visitWindowMovedEvent: aWindowMovedEvent [
	
]

{ #category : #'events-processing' }
OSGlutinWindowHandle >> visitWindowRefreshEvent: aWindowRefreshEvent [
]

{ #category : #'events-processing' }
OSGlutinWindowHandle >> visitWindowResizedEvent: aWindowResizedEvent [
	self handle resize: (aWindowResizedEvent width @ aWindowResizedEvent height).
	
	^ (OSWindowResizeEvent for: osWindow)
		width: aWindowResizedEvent width;
		height: aWindowResizedEvent height;
		deliver
]

{ #category : #accessing }
OSGlutinWindowHandle >> winitWindow [
	<return: #WinitWindow>

	^ self handle
]