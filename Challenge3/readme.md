## Challenge 3 - Advancing Real-World Apps

**Expected Duration:** 120 minutes

## Introduction

Great! You have now have a fully developed agent framework implemented. What other processes needed implementing? This open-ended challenge will guide you through some ideas on how to make your app robust, and more closely related to a production-ready scenario. 

Up next you will find some ideas that you can implement, tips and accelerators. However, if none of these ideas fit your use case feel free to implement others. You have your coaches available to help you on this journey.

## 1) Memory using Cosmos DB 🧠

Azure Cosmos DB is Microsoft's globally distributed, multi-model database service designed for building highly responsive and scalable applications. In our multi-agent system, Cosmos DB provides several critical functions:

- **Persistence**: Agents can maintain state between sessions and interactions
- **Shared Memory**: Multiple agents can access the same knowledge base
- **Scalability**: The system can handle growing amounts of data as your application expands
- **Consistency**: Ensures data integrity across different parts of your application

### Memory Architecture

The memory system is built around the `CosmosBufferedChatCompletionContext` class, which extends AutoGen's `BufferedChatCompletionContext` to add persistence with Cosmos DB:

#### Data Models in Memory

The memory system stores several key data models:

- **Sessions**: Represents a user interaction session
- **Plans**: A structured workflow created by the PlannerAgent
- **Steps**: Individual actions in a plan
- **AgentMessages**: Communication between agents and users

Each model is stored as a document in Cosmos DB with a unique ID and partition key.

#### How Memory is Used in the Agents

Let's look at how the [HumanAgent](Challenge2\src\backend\agents\human.py)
 uses the memory system:

```python
@message_handler
async def handle_step_feedback(
    self, message: HumanFeedback, ctx: MessageContext
) -> None:
    """
    Handles the human feedback for a single step from the GroupChatManager.
    Updates the step status and stores the feedback in the session context.
    """
    # Retrieve the step from the context
    step: Step = await self._memory.get_step(message.step_id, message.session_id)
    if not step:
        logging.info(f"No step found with id: {message.step_id}")
        return

    # Update the step status and feedback
    step.status = StepStatus.completed
    step.human_feedback = message.human_feedback
    await self._memory.update_step(step)
    await self._memory.add_item(
        AgentMessage(
            session_id=message.session_id,
            user_id=self.user_id,
            plan_id=step.plan_id,
            content=f"Received feedback for step: {step.action}",
            source="HumanAgent",
            step_id=message.step_id,
        )
    )
    logging.info(f"HumanAgent received feedback for step: {step}")
    track_event_if_configured(
        f"Human Agent - Received feedback for step: {step} and added into the cosmos",
        {
            "session_id": message.session_id,
            "user_id": self.user_id,
            "plan_id": step.plan_id,
            "content": f"Received feedback for step: {step.action}",
            "source": "HumanAgent",
            "step_id": message.step_id,
        },
    )

    # Notify the GroupChatManager that the step has been completed
    await self._memory.add_item(
        ApprovalRequest(
            session_id=message.session_id,
            user_id=self.user_id,
            plan_id=step.plan_id,
            step_id=message.step_id,
            agent_id=self.group_chat_manager_id,
        )
    )
    logging.info(f"HumanAgent sent approval request for step: {step}")
```

#### How to Use the Memory System

Here's how you can interact with the memory system in your code:

1. **Initialize the memory context**:

```python
memory = CosmosBufferedChatCompletionContext(
    session_id="your-session-id",
    user_id="user-123",
    buffer_size=100 # Keep this many messages in memory
)
```

2. **Store data**:

```python
# Add a plan
await memory.add_plan(my_plan)
# Add a step
await memory.add_step(my_step)
# Update a step
step.status = StepStatus.completed
await memory.update_step(step)
# Add a message
await memory.add_item(
    AgentMessage(
        session_id="session-123",
        user_id="user-123",
        content="Hello from agent!",
        source="YourCustomAgent"
    )
)
```

3. **Retrieve data**:

```python
#Get a plan
plan = await memory.get_plan_by_session(session_id="session-123")
#Get steps for a plan
steps = await memory.get_steps_by_plan(plan_id=plan.id)
#Get agent messages
messages = await memory.get_data_by_type("agent_message")
```


#### Customizing the Memory System

You might want to customize the memory system for your specific use case. Here are some ideas:

1. **Add new data models**: Extend the `MODEL_CLASS_MAPPING` to include your custom models
2. **Implement caching**: Add a caching layer to reduce database calls
3. **Add search capabilities**: Implement semantic search over your agent messages
4. **Optimize partitioning**: Adjust the partition key strategy for better performance
5. **Add memory summarization**: Implement a method to summarize long conversations

##### Example: Adding a Custom Data Model

```python
# 1. Create your model in models/messages.py
class CustomData(BaseDataModel):
    custom_field: str
    other_field: int

# 2. Update the MODEL_CLASS_MAPPING in CosmosBufferedChatCompletionContext
MODEL_CLASS_MAPPING = {
    "session": Session,
    "plan": Plan,
    "step": Step,
    "agent_message": AgentMessage,
    "custom_data": CustomData # Add your model here
}

# 3. Add methods to work with your model
async def add_custom_data(self, data: CustomData) -> None:
    await self.add_item(data)

# 4. Add a method to retrieve your model
async def get_custom_data(self, session_id: str) -> List[CustomData]:
    query = "SELECT FROM c WHERE c.session_id=@session_id AND c.data_type=@data_type"
    parameters = [
    {"name": "@session_id", "value": session_id},
    {"name": "@data_type", "value": "custom_data"},
    ]
    return await self.query_items(query, parameters, CustomData)
```
By understanding and customizing the memory system, you can create more powerful and personalized agent experiences that remember past interactions and build upon them.


### 2) Azure Deployment

### 3) Monitoring and Logging 📜

