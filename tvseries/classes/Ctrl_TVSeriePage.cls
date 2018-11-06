public class Ctrl_TVSeriePage {

	public TV_Serie__c tv_series;
	public TV_Serie__c hero{
		get;set;
	}
	public String title{
		get;set;
	}
	public Season__c addedSeason{
		get;set;
	}
	public List<TV_Serie__c> szukaneId{
		get;set;
	}
	public List<Played__c> actors{
		get;set;
	}
	public List<Episode__c> episodes {
		get;set;
	}
	public List<Season__c> seasons {
		get;set;
	}
	public List<Gallery__c> screens{
		get;set;
	}
	public TV_Serie__c tv{
		get;set;
	}
	public blob photo{
		get;set;
	}
	public String photourl{
		get;set;
	}
	public blob screenshot{
		get;set;
	}
	public String screenshotUrl{
		get;set;
	}
	String seriesId {
		get; set;
	}
	String selectedSeriesId = ApexPages.currentPage().getParameters().get('id');
	public boolean editSection {
		get;set;
	}
	public boolean seasonSection{
		get;set;
	}
	public boolean newSeason{
		get;set;
	}
	public Double numberOfSeason{
		get;set;
	}
	public Integer givenSeasonNumber{
		get;set;
	}


	public Ctrl_TVSeriePage(ApexPages.StandardController stdController) {

		this.tv_series = (TV_Serie__c)stdController.getRecord();
		searchAll();
		displayScreenshots();
		numberOfSeason = 0;
		searchCast();

	}


	public String Selected1 {
		get
			{
				if (Selected1 == null) {

					Selected1 = 'All';
				}
				return Selected1;
			}
		set;
	}

	public PageReference searchAll() {
		String alltogether;
		episodes = [select id, Episode_Number__c, Episode_No__c, Number_of_Season__c, Title__c
				from Episode__c where TV_Serie__c=:selectedSeriesId
		ORDER BY Episode_Number__c ASC];

		return null;
	}

	public PageReference searchEpisodes() {

		String selectedSeason = Selected1;


		if (Selected1 == 'All') {

			searchAll();
		} else if (Selected1 != 'All') {

			episodes = [select id, Episode_Number__c, Episode_No__c, Number_of_Season__c, Title__c from Episode__c
					WHERE Number_of_Season__c=:selectedSeason
			and TV_Serie__c=:selectedSeriesId
			ORDER BY Episode_No__c ASC];

		}

		return null;
	}

	public List<SelectOption> getSeason() {

		List<SelectOption> options = new List<SelectOption>();
		List<Season__c> seasonList = new List<Season__c>();
		List<String> result = new List<String>();
		String xd = 'a0A1t000001GK1REAW';
		seriesId = tv_series.Id;


		//select Season_No__c From Season__c Where TV_Serie__c ='a0A1t000001GK1REAW' EXAMPLE
		seasonList = [select Season_No__c FROM Season__c WHERE TV_Serie__c = :seriesId];

		if (seasonList.size() > 0) {
			for (Season__c x : seasonList) {

				result.add(String.valueOf(x.get(Season__c.Season_No__c)));

			}
			String temp = result[0];
			for (Integer i = 0; i < result.size() - 1; i++) {

				for (Integer j = 0; j < result.size() - 1; j++) {

					If (result[j + 1] < result[j]) {
						temp = result[j];
						result[j] = result[j + 1];
						result[j + 1] = temp;
					}
				}

			}
			options.add(new SelectOption('All', 'All'));

			for (String str : result) {

				options.add(new SelectOption(str, str));
			}
		} else {

			options.add(new SelectOption('All', 'All'));
		}


		return options;
	}

	public PageReference edittheSection() {
		if (editSection == true) {
			editSection = false;
		} else
		{
			editSection = true;
		}
		return null;
	}

	public List<SelectOption> getCountry() {
		List<SelectOption> options = new List<SelectOption>();
		Schema.DescribeFieldResult fieldResult = TV_Serie__c.Country__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();


		options.add(new SelectOption('-', '-'));

		for (Schema.PicklistEntry f : ple)
			{
				options.add(new SelectOption(f.getLabel(), f.getValue()));
			}


		System.debug(options);
		return options;
	}

	public List<SelectOption> getCategory() {
		List<SelectOption> options = new List<SelectOption>();
		Schema.DescribeFieldResult fieldResult = TV_Serie__c.Category__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();


		options.add(new SelectOption('-', '-'));

		for (Schema.PicklistEntry f : ple)
			{
				options.add(new SelectOption(f.getLabel(), f.getValue()));
			}

		System.debug(options);
		return options;
	}

	public void saveChanges() {

		try {
			TV_Serie__c tv_serie2 =
			[select Id, Description__c, Title__c, Category__c, Country__c, Release_Date__c FROM TV_Serie__c WHERE id=:seriesId];

			tv_serie2.Title__c = tv_series.Title__c;
			tv_serie2.Category__c = tv_series.Category__c;
			tv_serie2.Country__c = tv_series.Country__c;
			tv_serie2.Release_Date__c = tv_series.Release_Date__c;
			tv_serie2.Description__c = tv_series.Description__c;
			tv_serie2.Trailer__c = tv_series.Trailer__c;


			Database.SaveResult saveResult = Database.update(tv_serie2, false);
			if (saveResult.isSuccess() == true)
			{
				editSection = false;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'Update successfukl!'));
				system.debug('Update sucessful');

			} else
			{
				system.debug(logginglevel.ERROR, 'Update fail!');
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Update Fail!'));

			}
		} catch (exception ex)
		{
			system.debug(logginglevel.ERROR, 'cannot save update' + ex);
			editSection = true;

		}

	}

	//		public PageReference goToEpisodes(){
	//
	//			String newID = '/apex/TVSerieAddSEPage?id='+selectedSeriesId+'&sfdc.override=1';
	//			PageReference orderPage = new PageReference(newID);
	//			orderPage.setRedirect(true);
	//			return orderPage;
	//		}

	public PageReference createSeasonSection() {

		if (seasonSection == true) {
			seasonSection = false;
		} else {
			seasonSection = true;
			searchSeries();
		}
		return null;
	}

	public PageReference searchSeries() {

		seasons = [select id, Season_No__c from Season__c where TV_Serie__c =:selectedSeriesId
		ORDER BY Season_No__c ASC];

		return null;
	}

	public PageReference newSeasonSection() {

		newSeason = true;

		return null;

	}

	public void checkSeason() {

		List<Season__c> checkSearch = [select id, Season_No__c from Season__c
				where (Season_No__c=:givenSeasonNumber and TV_Serie__c=:selectedSeriesId )];
		if (checkSearch.size() > 0) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The season already exists'));
		}

	}

	public void addNewSeason() {
		Season__c createdSeason = new Season__c();

		//System.debug('Number of Season '+addedSeason.Season_No__c+' Id '+selectedSeriesId);
		List<Season__c> checkSearch = [select id, Season_No__c from Season__c
				where (Season_No__c=:givenSeasonNumber and TV_Serie__c=:selectedSeriesId )];
		if (checkSearch.size() > 0) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The season already exists'));
		} else {
			try {
				if (givenSeasonNumber != null && givenSeasonNumber > 0) {
					system.debug('value = ' + givenSeasonNumber);
					createdSeason.Season_No__c = givenSeasonNumber;
					createdSeason.TV_Serie__c = selectedSeriesId;

					Database.SaveResult saveResult = Database.insert(createdSeason, false);
					if (saveResult.isSuccess())
					{
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Insert Successful'));
						system.debug('success');
						searchAll();
						searchSeries();

					}
				} else {
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'incorect data'));
					system.debug('wrong data');
				}
			} catch (exception ex) {
				system.debug(logginglevel.ERROR, 'Error');
			}
		}

	}


	public PageReference deleteSerie() {

		List<TV_Serie__c> destroySerie = [SELECT Id, Name FROM TV_Serie__c
				WHERE id=:selectedSeriesId];
		try {
			delete destroySerie;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'Delete successful!'));
			system.debug('Delete sucessful');
			PageReference refPage = new PageReference('/apex/SeriesSearch?');
			return refPage;


		} catch (DmlException e) {

			//system.debug(logginglevel.ERROR, 'Delete fail!');
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Delete Fail!'));
			return null;
		}
		return null;
	}

	public void deleteAllSeasons() {

		List<Season__c> destroySeasons = [select id, name from Season__c where TV_Serie__r.Id=:selectedSeriesId];

		try {
			delete destroySeasons;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'Delete successful!'));
			system.debug('Delete sucessful');
			searchAll();
			searchSeries();
			searchEpisodes();
		} catch (DmlException e) {

			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Delete Fail!'));
		}
	}

	public PageReference UploadPhoto() {
		try {


			Attachment objA = new Attachment();
			objA.body = photo;
			objA.name = 'logo';
			objA.parentid = tv_series.id;
			objA.ContentType = 'application/jpg';
			insert objA;
			string Attid = objA.id;
			string attachmentid = Attid.substring(0, 15);
			tv_series.Image_Id__c = '/servlet/servlet.FileDownload?file=' + attachmentid;
			update tv_series;
			photourl = tv_series.Image_Id__c;

			//				PageReference pageRef = new PageReference('/apex/TVSeriePage?id='+selectedSeriesId+'&sfdc.override=1');
			//				return pageRef;
			ApexPages.addMessage(
					new ApexPages.message(ApexPages.severity.Info, 'Logo Updated, should be visible soon!'));

		} catch (Exception e) {
			system.debug('Exception message' + e);
			return null;
		}
		return null;
	}


	public void displayScreenshots() {

		screens = [select id, Screenshot__c, ScreenshotDisplay__c from Gallery__c where TV_Serie__c=:tv_series.Id ];


	}

	public void UploadScreens() {
		try {

			Gallery__c galleryObj = new Gallery__c();
			Attachment objA = new Attachment();
			objA.body = screenshot;
			objA.name = 'screenshot';
			objA.parentid = tv_series.id;
			objA.ContentType = 'application/jpg';
			insert objA;
			string Attid = objA.id;
			string attachmentid = Attid.substring(0, 15);
			galleryObj.TV_Serie__c = tv_series.id;
			galleryObj.Screenshot__c = '/servlet/servlet.FileDownload?file=' + attachmentid;
			insert galleryObj;


			ApexPages.addMessage(
					new ApexPages.message(ApexPages.severity.Info, 'Logo Updated, should be visible soon!'));

		} catch (Exception e) {
			system.debug('Exception message' + e);

		}

	}

	public void searchCast() {
		actors = [select Character__c, id,Cast__r.id, Cast__r.Full_Name__c, Cast__r.Photo__c
				from Played__c where TV_Serie__c=:selectedSeriesId];


	}

	public void showChosen() {


	}

	public void addActor() {


	}


}