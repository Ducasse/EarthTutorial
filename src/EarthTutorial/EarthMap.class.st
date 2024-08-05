Class {
	#name : 'EarthMap',
	#superclass : 'Object',
	#instVars : [
		'countries'
	],
	#category : 'EarthTutorial',
	#package : 'EarthTutorial'
}

{ #category : 'as yet unclassified' }
EarthMap >> countryNames [

	^ countries collect: [ :each | each name ]
]

{ #category : 'importing' }
EarthMap >> importCountriesFrom: aFileName [

	(self xmlTreeFromFile: aFileName) nodes first nodes do: [ :node |
		node class = XMLElement ifTrue: [
			self importCountryFromXMLNode: node ] ]
]

{ #category : 'importing' }
EarthMap >> importCountryFromXMLNode: aXMLElement [

	countries add: (EarthMapCountry new fromXML: aXMLElement)
]

{ #category : 'initialization' }
EarthMap >> initialize [

	super initialize.
	countries := OrderedCollection new
]

{ #category : 'visualisation' }
EarthMap >> openPopulatedCanvas [

	self populatedCanvas open 
]

{ #category : 'visualisation' }
EarthMap >> populatedCanvas [

	^ RSCanvas new
		addAll: (countries collect: [ :country | country asRSShape]) ;
		@ RSCanvasController ;
		yourself
]

{ #category : 'importing' }
EarthMap >> xmlTreeFromFile: aFileName [

	^ aFileName asFileReference readStreamDo: [ :stream |
		(XMLDOMParser parse: stream) document ]
]
