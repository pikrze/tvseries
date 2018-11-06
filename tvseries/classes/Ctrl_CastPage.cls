/*
 * Created by piotr.krzeminski on 30.10.2018.
 */
public class Ctrl_CastPage {
    public Cast__c tv_cast;
    public Cast__c cas{get;set;}
	public String title{get;set;}
   // public String idSearch{get;set;}
	public boolean assign{get;set;}
	public List<Played__c> displayedSeries{get;set;}
	public String playedCharacter{get;set;}
        public List<String> roles{
        get; set;
    }
	public List<TV_Serie__c> series{
		get;set;
	}
	public boolean editSection{
		get;set;
	}
	public blob photo{
		get;set;
	}
	public String photourl{
		get;set;
	}
	String selectedCastId = ApexPages.currentPage().getParameters().get('id');

	public Ctrl_CastPage(ApexPages.StandardController stdController) {

		this.tv_cast = (Cast__c)stdController.getRecord();
		//searchAll();
		displaySeries();
        cas = new Cast__c();

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

	public List<SelectOption> getCategory() {
		List<SelectOption> options = new List<SelectOption>();
		Schema.DescribeFieldResult fieldResult = Cast__c.Role__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();


		options.add(new SelectOption('-', '-'));

		for (Schema.PicklistEntry f : ple)
			{
				options.add(new SelectOption(f.getLabel(), f.getValue()));
			}


		System.debug(options);
		return options;
	}
	public List<SelectOption> getCountry() {
		List<SelectOption> options = new List<SelectOption>();
		Schema.DescribeFieldResult fieldResult = Cast__c.Nationality__c.getDescribe();
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
			Cast__c tv_cast2 =
			[select Id,Biography__c, Name__c, Surname__c, Birth_Date__c, Role__c FROM Cast__c WHERE id=:selectedCastId];

			tv_cast2.Name__c = tv_cast.Name__c;
			tv_cast2.Surname__c = tv_cast.Surname__c;
			
			tv_cast2.Birth_Date__c = tv_cast.Birth_Date__c;
			tv_cast2.Biography__c = tv_cast.Biography__c;
			tv_cast2.Nationality__c = tv_cast.Nationality__c;

             String roleList ='';
                               
                for(Integer i = 0; i<roles.size(); i++ )
                {
                    if(i == roles.size()-1){
                        roleList += roles[i];
                    }else{
                    roleList += roles[i] +';';
                    }
                    
                }
                tv_cast2.Role__c = roleList;

			Database.SaveResult saveResult = Database.update(tv_cast2, false);
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

	public PageReference UploadPhoto() {
		try {


			Attachment objA = new Attachment();
			objA.body = photo;
			objA.name = 'logo';
			objA.parentid = tv_cast.id;
			objA.ContentType = 'application/jpg';
			insert objA;
			string Attid = objA.id;
			string attachmentid = Attid.substring(0, 15);
			tv_cast.Photo_Id__c = '/servlet/servlet.FileDownload?file=' + attachmentid;
			update tv_cast;
			photourl = tv_cast.Photo_Id__c;

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

	public PageReference searchAll() {
		//String searchText = '%'+title+'%';
        
       
        String searchText = cas.TV_Serie__c;
                                                                                                                               
       // if(idSearch!=null){
		//series = [select id, name, Country__c, TItle__c, Release_Date__c
		//		from TV_Serie__c where (Title__c LIKE :searchText OR id=:idSearch) LIMIT 2];
		//System.debug('ID :'+string.valueOf(series[0].id));
       // }else{
			series = [select id, name, Country__c, TItle__c, Release_Date__c
				from TV_Serie__c where (id=:searchText) LIMIT 1];
       // }
       System.debug('sample '+searchText);

		return null;
	}

	public void assignToSerie(){

		Played__c played1 = new Played__c();

		String selectedSeriesId = string.valueOf(series[0].id);



			try {
				if (selectedSeriesId != null && selectedCastId != null) {

					played1.TV_Serie__c = selectedSeriesId;
					played1.Cast__c = selectedCastId;
					played1.Character__c = playedCharacter;

					Database.SaveResult saveResult = Database.insert(played1, false);
					if (saveResult.isSuccess())
					{
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Insert Successful'));
						system.debug('success');
						displaySeries();

					}
				} else {
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'incorect data'));
					system.debug('wrong data');
				}
			} catch (exception ex) {
				system.debug(logginglevel.ERROR, 'Error');
			}
		}

		public void displaySeries(){

			displayedSeries = [select id, TV_Serie__r.Id, Character__c,Cast__r.Role__c, TV_Serie__r.Title__c, TV_Serie__r.Release_Date__c from Played__c
								where Cast__c=:selectedCastId
								ORDER BY TV_Serie__r.Release_Date__c ASC];


		}
    
   public PageReference deleteCast() {

		List<Cast__c> destroyCast = [SELECT Id, Name FROM Cast__c
				WHERE id=:selectedCastId];
		try {
			delete destroyCast;
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


	}