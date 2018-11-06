public with sharing class Ctrl_SeriesSearch
{
	public List<TV_Serie__c> series { get; set; }
	//public List<String> releaseDates{get; set;}
	public String title { get; set; }
	public String nameOrSurname{get;set;}
	public List<SelectOption> categories {get; set;}
	public List<SelectOption> countries{get; set;}
	public List<SelectOption> dates{get; set;}
	public List<Cast__c> tv_cast{get;set;}
	public String Selected1 {
		get
			{
				if(Selected1==null) {

					Selected1 = 'None';
				}
				return Selected1;
			}
		set;
	}
	public String Selected2{get
		{
			if(Selected2==null) {

				Selected2 = 'None';
			}
			return Selected2;
		}
		set;
	}
	public String Selected3 {
		get
			{
				if(Selected3==null) {

					Selected3 = 'None';
				}
				return Selected3;
			}
		set;
	}
	public String Selected4 {
		get
			{
				if(Selected4==null) {

					Selected4 = 'None';
				}
				return Selected4;
			}
		set;
	}
	public String Selected5 {
		get
			{
				if(Selected5==null) {

					Selected5 = 'None';
				}
				return Selected5;
			}
		set;
	}


	public Ctrl_SeriesSearch() {
		series = new List<TV_Serie__c>();
		noSearch();
		noSearchCast();
	}


	public PageReference searchSeries() {
		String searchText = '%'+title+'%';


		if( (Selected1 != 'None' && Selected2 != 'None') && Selected3 != 'None') {
			series = [select Id, Title__c,
					Release_Date__c, Category__c, Country__c, Logo__c
					from TV_Serie__c
					where ((Title__c LIKE :searchText AND Category__c LIKE :Selected1)
			AND Country__c LIKE :Selected2) AND Year__c LIKE :Selected3 ORDER BY Title__c ASC LIMIT 20];


		}else if( Selected1 != 'None' && Selected2 != 'None') {
			series = [select Id, Title__c,
					Release_Date__c, Category__c, Country__c, Logo__c
					from TV_Serie__c
					where (Title__c LIKE :searchText AND Category__c LIKE :Selected1)
			AND Country__c LIKE :Selected2  ORDER BY Title__c ASC LIMIT 20];


		}else if( Selected1 != 'None'  && Selected3 != 'None') {
			series = [select Id, Title__c,
					Release_Date__c, Category__c, Country__c, Logo__c
					from TV_Serie__c
					where (Title__c LIKE :searchText AND Category__c LIKE :Selected1)
			AND Year__c LIKE :Selected3  ORDER BY Title__c ASC LIMIT 20];


		}else if( Selected2 != 'None' && Selected3 != 'None') {
			series = [select Id, Title__c,
					Release_Date__c, Category__c, Country__c, Logo__c
					from TV_Serie__c
					where (Title__c LIKE :searchText AND Country__c LIKE :Selected2)
			AND Year__c LIKE :Selected3  ORDER BY Title__c ASC LIMIT 20];


		}else if(Selected1 != 'None'){

			series = [select Id, Title__c,
					Release_Date__c, Category__c, Country__c, Logo__c
					from TV_Serie__c
					where (Title__c LIKE :searchText AND Category__c LIKE :Selected1) ORDER BY Title__c ASC LIMIT 20];

		}else if(Selected2 != 'None'){

			series = [select Id, Title__c,
					Release_Date__c, Category__c, Country__c, Logo__c
					from TV_Serie__c
					where (Title__c LIKE :searchText AND Country__c LIKE :Selected2) ORDER BY Title__c ASC LIMIT 20];
		}else if(Selected3 != 'None'){

			series = [select Id, Title__c,
					Release_Date__c, Category__c, Country__c, Logo__c
					from TV_Serie__c
					where (Title__c LIKE :searchText AND Year__c LIKE :Selected3)  ORDER BY Title__c ASC LIMIT 20];
		}else{
			series = [select Id, Title__c,
					Release_Date__c, Category__c, Country__c, Logo__c
					from TV_Serie__c
					where Title__c LIKE :searchText  ORDER BY Title__c ASC LIMIT 20];

		}


		return null;

	}


	public PageReference noSearch(){

		series = [select Id, Title__c,
				Release_Date__c, Category__c, Country__c, Logo__c
				from TV_Serie__c  ORDER BY Title__c ASC LIMIT 20];



		return null;
	}



	public List<SelectOption> getCategory() {
		List<SelectOption> options = new List<SelectOption>();
		Schema.DescribeFieldResult fieldResult = TV_Serie__c.Category__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();


		options.add(new SelectOption('None','None'));

		for( Schema.PicklistEntry f : ple)
			{
				options.add(new SelectOption(f.getLabel(), f.getValue()));
			}




		System.debug(options);
		return options;
	}

	public List<SelectOption> getCountry() {
		List<SelectOption> options = new List<SelectOption>();
		Schema.DescribeFieldResult fieldResult = TV_Serie__c.Country__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();


		options.add(new SelectOption('None','None'));

		for( Schema.PicklistEntry f : ple)
			{
				options.add(new SelectOption(f.getLabel(), f.getValue()));
			}




		System.debug(options);
		return options;
	}

	public  List<SelectOption> getReleaseDate(){

		List<SelectOption> options = new List <SelectOption>();
		List<TV_Serie__c> rDates = new List<TV_Serie__c>();
		List<String> releaseDates = new List<String>();

		rDates = [SELECT Year__c
				FROM TV_Serie__c];

		//releaseDates.add(rDates[0].Year__c);

		for(TV_Serie__c x: rDates){

			releaseDates.add(x.Year__c);

		}

		Set<String> myset = new Set<String>();
		List<String> result = new List<String>();
		myset.addAll(releaseDates);
		result.addAll(myset);

		String temp = result[0];
		for(Integer i = 0; i<result.size()-1; i++){

			for(Integer j = 0; j<result.size()-1; j++){

				If(result[j+1]<result[j]){
					temp = result[j];
					result[j] = result[j+1];
					result[j+1] = temp;
				}
			}

		}

		System.debug(result);





		options.add(new SelectOption('None', 'None'));
		for( String str : result)
			{
				options.add(new SelectOption(str,str));
			}




		return options;


	}
	public void noSearchCast(){


		tv_cast = [select id, Photo__c, Name__c, Surname__c, Role__c, Birth_Date__c, Full_Name__c FROM Cast__c];
	}

	public void searchCast(){
		String searchText = '%'+nameOrSurname+'%';

		if(Selected4 != 'None') {

			tv_cast = [select Nationality__c, Role__c,id, Photo__c, Full_Name__c, Name__c, Surname__c, Birth_Date__c FROM Cast__c
						Where ((Role__c INCLUDES (:Selected4) ))AND Full_Name__c LIKE :searchText
						ORDER BY Surname__c ASC LIMIT 20];
		}else if(Selected5 != 'None'){

			tv_cast = [select Nationality__c, Role__c, id, Photo__c,Full_Name__c, Name__c, Surname__c, Birth_Date__c FROM Cast__c
					Where (Nationality__c LIKE :Selected5) AND Full_Name__c LIKE :searchText
					ORDER BY Surname__c ASC LIMIT 20];
		}else if(Selected4 != 'None' && Selected5 != 'None'){

			tv_cast = [select Nationality__c, Role__c, id, Photo__c,Full_Name__c, Name__c, Surname__c, Birth_Date__c FROM Cast__c
					Where ((Nationality__c LIKE :Selected5) AND Role__c INCLUDES (:Selected4))
					AND Full_Name__c LIKE :searchText
					ORDER BY Surname__c ASC LIMIT 20];

		}else{
			tv_cast = [select Nationality__c, Role__c, id, Photo__c, Full_Name__c, Name__c, Surname__c, Birth_Date__c FROM Cast__c
					Where  Full_Name__c LIKE :searchText
					ORDER BY Surname__c ASC LIMIT 20];

		}


	}

	public List<SelectOption> getNationality() {
		List<SelectOption> options = new List<SelectOption>();
		Schema.DescribeFieldResult fieldResult = Cast__c.Nationality__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();


		options.add(new SelectOption('None','None'));

		for( Schema.PicklistEntry f : ple)
			{
				options.add(new SelectOption(f.getLabel(), f.getValue()));
			}




		System.debug(options);
		return options;
	}
	public List<SelectOption> getRole() {
		List<SelectOption> options = new List<SelectOption>();
		Schema.DescribeFieldResult fieldResult = Cast__c.Role__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();


		options.add(new SelectOption('None','None'));

		for( Schema.PicklistEntry f : ple)
			{
				options.add(new SelectOption(f.getLabel(), f.getValue()));
			}




		System.debug(options);
		return options;
	}

	public PageReference actorPageNew(){

		PageReference page = new PageReference('/apex/CastCreatePage');
		return page;
	}
    	public PageReference seriePageNew(){

		PageReference page = new PageReference('/apex/TVSerieCreatePage');
		return page;
	}



}