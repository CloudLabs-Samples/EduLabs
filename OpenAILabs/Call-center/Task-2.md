## Task 2: Upload audio file 

In this task , you will upload a audio file which will be converted to text transcription and then further it will be analysed using Azure Open AI and Function App

1. Ensure all the three function apps are **Running**

   ![](images/s8.png)

2. Navigate to the Storage account **callcenterstore<inject key="Deployment-id" enableCopy="false"></inject>**

3. Select **Containers** from the **Data Storage** section, select the **audio-input** container

   ![](images/25.png)

4. Next, upload any audio file from the VM Path:**C:\LabFiles\Recordings** to the **audio-input** container

    ![](images/26.png)

5. The audio file or the call recording uploaded to the **audio-input** will be processed and transcribed in JSON format to another container **json-result-output**

When a file lands in a storage container **audio-input**, the Grid event indicates the completed upload of a file. The file is filtered and pushed to a Service bus topic. Code in Azure Functions **StartTranscriptionFunction** is triggered by a timer picks up the event and creates a transmission request using the Azure Speech services batch pipeline. When the transmission request is complete, an event is placed in another queue in the same service bus resource. A different Azure Function **FetchTranscriptionFunction** triggered by the completion event starts monitoring transcription completion status. When transcription completes, the Azure Function copies the transcript into the **json-result-output** container.

Next, using the code of **ProcessBlobTrigger** function the JSON file(transcript) from the **json-result-output** container is further analyzed using **Azure OpenAI** resource and the **Conversation summary** ,sentiment analysis whether it is **Positive or Negative** is further loaded to a **SQL Database** which will be used for Visualization in the next task

6. Wait for atleast 5-6 mins for the to see the json files in **json-result-output** container.

### End of Task-2

## Proceed with next task
