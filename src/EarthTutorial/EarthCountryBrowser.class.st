Class {
	#name : 'EarthCountryBrowser',
	#superclass : 'SpPresenterWithModel',
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
	
	| inst |
	inst := self on: (EarthMap new importCountriesFrom:
		       FileSystem workingDirectory / 'pharo-local' / 'iceberg'
		       / 'EarthTutorial' / 'resources' / 'world.svg').
	inst open
]

{ #category : 'initialization' }
EarthCountryBrowser >> connectPresenters [

	countryList whenSelectedItemChangedDo: [ :item |
    self onCountrySelected: item ].
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
	request get: 'https://flagcdn.com/w320/' , astring asLowercase , '.png'.
	request isSuccess ifTrue: [
		pngArray := request response contents.
		^ ImageReadWriter formFromStream: (ReadStream on: pngArray) ].
	^ BorderedMorph new asForm
]

{ #category : 'initialization' }
EarthCountryBrowser >> initializePresenters [

	super initializePresenters.

	countryList := self newDropList.
	countryList display: [ :item | item name ].
	countryList sortingBlock: [ :a :b | a model name < b model name ].
	countryList items: self model countries.
	
	countryCode := self newTextInput.
	countryCode editable: false.
	countryCode text: '   --   '.
	countryFlag := self newImage
]

{ #category : 'initialization' }
EarthCountryBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Country Flag Browser'
]

{ #category : 'initialization' }
EarthCountryBrowser >> onCountrySelected: countryItem [

	countryCode text: '    ', countryItem code.
	self showFlag: countryItem code
]

{ #category : 'initialization' }
EarthCountryBrowser >> showFlag: aStringCode [ 

	countryFlag image: (self flagForCountryCode: aStringCode).
]
