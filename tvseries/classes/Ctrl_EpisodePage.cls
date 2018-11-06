/*
 * Created by piotr.krzeminski on 25.10.2018.
 */
public class Ctrl_EpisodePage {

	public Episode__c episode;
	public List<Episode__c> season{get;set;}
	public List<Episode__c> episodes{get;set;}
	public List<Episode__c> tvserie{get;set;}
	public boolean editSection{get;set;}
	String selectedTVSerieID{get;set;}
	String selectedSeasonId{get;set;}
	String selectedEpisodeId = ApexPages.currentPage().getParameters().get('id');
	public Ctrl_EpisodePage(ApexPages.StandardController stdController) {

		this.episode= (Episode__c)stdController.getRecord();
		searchAll();

	}

	public void searchAll(){

		episodes = [select Episode__c.Description__c, id, Title__c, TV_Serie__r.Title__c, Episode_No__c, Episode__c.Season__r.Season_No__c
		from Episode__c where id=:selectedEpisodeId];
		season = [select Season__c from Episode__c where id=:selectedEpisodeId limit 1];

		selectedSeasonId = string.valueOf(season[0].Season__c);
		tvserie = [select TV_Serie__c from Episode__c where id=:selectedEpisodeId limit 1];
		selectedTVSerieID = string.valueOf(tvserie[0].TV_Serie__c);

	}


	public PageReference edittheSection(){
		if(editSection==true){
			editSection = false;
		}else
		{
			editSection = true;
		}
		return null;
	}

	public void saveChanges(){

		try {
			Episode__c episode2 = [select Id, Description__c, Episode_No__c, Title__c FROM Episode__c WHERE id=:selectedEpisodeId];

			//episode2.Episode_No__c  = episode.Episode_No__c;
			episode2.Description__c = episode.Description__c;
			episode2.Title__c = episode.Title__c;


			Database.SaveResult saveResult= Database.update(episode2, false);
			if (saveResult.isSuccess() == true )
			{
				editSection = false;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'Update successfukl!'));
				system.debug('Update sucessful');
			}
			else
			{
				system.debug(logginglevel.ERROR, 'Update fail!');
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Update Fail!'));
			}
		}
		catch (exception ex)
		{
			system.debug(logginglevel.ERROR, 'cannot save update' + ex);
			editSection = true;
		}
	}

	public PageReference deleteEpisode(){

		List<Episode__c> destroyEpisode = [select id, name from Episode__c where Episode__c.Id=:selectedEpisodeId];

		try{
			delete destroyEpisode;

			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'Delete successfukl!'));
			system.debug('Delete sucessful');

			PageReference pageRef = new PageReference('/apex/SeasonPage?id='+selectedSeasonId);
			return pageRef;

		}catch(DmlException e){
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