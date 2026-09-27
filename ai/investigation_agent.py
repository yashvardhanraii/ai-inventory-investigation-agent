import json
import os

from azure.identity import DefaultAzureCredential
from azure.ai.projects import AIProjectClient


def build_investigation_prompt(payload):
    return f"""
You are an inventory investigation assistant.

Analyse the inventory issue using only the structured evidence provided below.

Your task:
1. Explain the most likely cause of the issue.
2. Assess the operational severity as Low, Medium, or High.
3. Recommend practical follow-up actions.
4. Do not invent facts that are not supported by the payload.
5. If the evidence is insufficient, say what additional information is needed.

Investigation payload:
{json.dumps(payload, indent=2)}

Return a concise response with:
- Likely cause
- Severity
- Recommended actions
"""


def investigate_inventory_issue(payload):
    project_endpoint = os.environ["AZURE_AI_PROJECT_ENDPOINT"]
    agent_name = os.environ["AZURE_AI_AGENT_NAME"]

    project_client = AIProjectClient(
        endpoint=project_endpoint,
        credential=DefaultAzureCredential()
    )

    prompt = build_investigation_prompt(payload)

    with project_client:
        agents = project_client.agents

        thread = agents.threads.create()

        agents.messages.create(
            thread_id=thread.id,
            role="user",
            content=prompt
        )

        run = agents.runs.create_and_process(
            thread_id=thread.id,
            agent_id=agent_name
        )

        if run.status != "completed":
            raise RuntimeError(
                f"Inventory investigation failed with status: {run.status}"
            )

        messages = list(
            agents.messages.list(
                thread_id=thread.id
            )
        )

        for message in messages:
            if message.role == "assistant" and message.text_messages:
                return message.text_messages[-1].text.value

    return "No investigation response was returned."


if __name__ == "__main__":
    example_payload = {
        "sku": "SKU-1045",
        "store": "MEL01",
        "quantity_on_hand": 12,
        "reorder_point": 30,
        "recent_sales_units": 48,
        "open_po_quantity": 50,
        "expected_delivery_date": "2026-09-24",
        "supplier_lead_time_days": 7,
        "days_overdue": 3,
        "recent_adjustments": 2,
        "waste_units": 4,
        "triggered_rules": [
            "BELOW_REORDER_POINT",
            "SUPPLIER_DELIVERY_OVERDUE"
        ]
    }

    result = investigate_inventory_issue(example_payload)

    print("\nInventory Investigation Result:\n")
    print(result)
