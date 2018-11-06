/*
 * Created by piotr.krzeminski on 25.10.2018.
 */
public class Ctrl_SeasonPage {

	public Season__c season;
	public List<Episode__c> episodes{get;set;}
	public Integer givenEpisodeNumber{get;set;}
	public String givenEpisodeTitle{get;set;}
	public List<Season__c> TVSerieId{get;set;}
	public String selectedTVSerieId{get;set;}
	String selectedSeasonId =ApexPages.currentPage().getParameters().get('id');

	public Ctrl_SeasonPage(ApexPages.StandardController stdController) {

		this.season= (Season__c)stdController.getRecord();
		searchAll();

	}

	public void searchAll(){


		episodes = [select id, Episode_No__c, Title__c, Episode_Number__c from Episode__c where Season__c=:selectedSeasonId
					ORDER BY Episode_No__c ASC];
		TVSerieId = [select TV_Serie__c from Season__c where id=:selectedSeasonId limit 1];

		selectedTVSerieId = string.valueOf(TVSerieId[0].TV_Serie__c);
		system.debug('search: '+TVSerieId[0].TV_Serie__c);

	}

	public void addNewEpisode(){
		Episode__c createdEpisode = new Episode__c();

		//System.debug('Number of Season '+addedSeason.Season_No__c+' Id '+selectedSeriesId);
		system.debug('value BEFORE IF = '+givenEpisodeNumber+' tvID = '+selectedTVSerieId);

		List<Episode__c> checkSearch = [select id, Episode_No__c from Episode__c
				where (Episode_No__c=:givenEpisodeNumber and Season__c=:selectedSeasonId )];
		if(checkSearch.size()>0){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The episode already exists'));
		}else {
			try {
				if (givenEpisodeNumber != null && givenEpisodeNumber > 0) {
					system.debug('value = ' + givenEpisodeNumber);
					createdEpisode.Episode_No__c = givenEpisodeNumber;
					createdEpisode.Season__c = selectedSeasonId;
					createdEpisode.TV_Serie__c = selectedTVSerieId;
					createdEpisode.Title__c = givenEpisodeTitle;
				}

				Database.SaveResult saveResult = Database.insert(createdEpisode, false);


				if (saveResult.isSuccess())
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Insert Successful'));
					system.debug('success');
					searchAll();


				}

				else {
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'incorect data'));
					system.debug('wrong data');
				}
			} catch (exception ex) {
				system.debug(logginglevel.ERROR, 'Error');
			}
		}

	}
	public void deleteAllEpisodes(){

		List<Episode__c> destroyEpisodes = [select id, name from Episode__c where Season__r.id=:selectedSeasonId];

		try {
			delete destroyEpisodes;
			//ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'Delete successful!'));
			system.debug('Delete sucessful');
			searchAll();
		} catch (DmlException e) {

			//system.debug(logginglevel.ERROR, 'Delete fail!');
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Delete Fail!'));

		}
	}

	public PageReference deleteSeason(){

		List<Season__c> destroySeason = [select id, name from Season__c where Season__c.Id=:selectedSeasonId];

		try{
			delete destroySeason;
			//ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'Delete successful!'));
			system.debug('Delete sucessful');


			system.debug('redirect to: '+selectedTVSerieId);
			PageReference pageRef = new PageReference('/apex/TVSeriePage?id='+selectedTVSerieId+'&sfdc.override=1');

			return pageRef;
		} catch(DmlException e){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Delete Fail!'));
			return null;
		}

		return null;
	}

	public PageReference backtoSerie(){

		PageReference pageRef = new PageReference('/apex/TVSeriePage?id='+selectedTVSerieId+'&sfdc.override=1');

		return pageRef;

	}





}