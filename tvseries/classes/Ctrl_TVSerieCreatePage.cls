/*
 * Created by piotr.krzeminski on 22.10.2018.
 */
public class Ctrl_TVSerieCreatePage {

	public TV_Serie__c tv_series{get;set;}
	public String title { get; set; }
	public String testValue{get;set;}
	public String description{ get; set; }
	public String selectedCategory {get; set;}
	public String selectedCountry {get; set;}
	public boolean  validation{ get; set; }

	public Ctrl_TVSerieCreatePage(ApexPages.StandardController stdController) {

		this.tv_series = new TV_Serie__c();


	}

	public List<SelectOption> getCategory() {
		List<SelectOption> options = new List<SelectOption>();
		Schema.DescribeFieldResult fieldResult = TV_Serie__c.Category__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();


		options.add(new SelectOption('-','-'));

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


		options.add(new SelectOption('-','-'));

		for( Schema.PicklistEntry f : ple)
			{
				options.add(new SelectOption(f.getLabel(), f.getValue()));
			}




		System.debug(options);
		return options;
	}

	public PageReference addSeries(){

		TV_Serie__c tv_serie2 = new TV_Serie__c();
		String newUrl;
		//System.debug(logginglevel.INFO,'Enter the addSeries Method');
		try
		{
			System.debug('wchodzimy w try');

			system.debug(title);
			if(tv_series.Title__c != null && tv_series.Category__c != null && tv_series.Country__c !=null
					&& tv_series.Release_Date__c != null) {
				System.debug('weszlismy w IFA');
				tv_serie2.Title__c = tv_series.Title__c;
				tv_serie2.Category__c = tv_series.Category__c;
				tv_serie2.Country__c = tv_series.Country__c;
				tv_serie2.Trailer__c = tv_serie2.Trailer__c;
				tv_serie2.Description__c = tv_series.Description__c;
				tv_serie2.Release_Date__c = tv_series.Release_Date__c;

				system.debug('co tu sie dzieje? '+tv_serie2.Title__c);

				Database.SaveResult saveResult= Database.insert(tv_serie2, false);
				if(saveResult.isSuccess())
					{
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Insert Successful'));
						newUrl = '/apex/TVSeriePage?id=' + tv_serie2.id + '&sfdc.override=1';
						PageReference pageRef = new PageReference(newUrl);
						return pageRef;
					}
				}
			else{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please be kind to fill in all of the required fields'));
				return null;
			}

			}
		catch (exception ex)
		{
			system.debug(logginglevel.ERROR, 'Error');
			return null;
		}
		 return null;

	}

	public void sprawdzamCzyDziala(){

		System.debug('WARTOSC: '+tv_series.Title__c);
	}

	}