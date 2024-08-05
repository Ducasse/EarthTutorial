Class {
	#name : 'EarthCountryBrowser',
	#superclass : 'SpPresenter',
	#instVars : [
		'countryList',
		'map',
		'countryCode',
		'countryFlag'
	],
	#category : 'EarthTutorial',
	#package : 'EarthTutorial'
}

{ #category : 'examples' }
EarthCountryBrowser class >> example [

	<script>
	self new open 
]

{ #category : 'layout' }
EarthCountryBrowser >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: countryList expand: true;
				   add: countryCode width: 40)
		  height: self class toolbarHeight;
		  add: countryFlag height: 350;
		  yourself
]

{ #category : 'utils' }
EarthCountryBrowser >> flagForCountryCode: astring [

	| request pngArray |
	request := ZnClient new.
	request get: 'https://flagcdn.com/w320/' , astring lowercase , '.png'.
	request isSuccess ifTrue: [
		pngArray := request response contents.
		^ ImageReadWriter formFromStream: (ReadStream on: pngArray) ].
	^ BorderedMorph new asForm
]

{ #category : 'initialization' }
EarthCountryBrowser >> initialize [
	
	super initialize.
	map := EarthMap new importCountriesFrom: (FileSystem workingDirectory / 'pharo-local' / 'iceberg' / 'EarthTutorial' / 'resources' /'world.svg' ).
]

{ #category : 'initialization' }
EarthCountryBrowser >> initializePresenters [

	super initializePresenters.

	countryList := self newDropList.
	countryList display: [ :item | item key ].
	countryList sortingBlock: [ :a :b | a model key < b model key ].

	countryCode := self newTextInput.
	countryCode editable: false.
	countryCode text: '   --   '.
	countryFlag := self newImage
]
