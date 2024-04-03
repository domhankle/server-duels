# This example requires the 'message_content' intent.

import discord
import os

intents = discord.Intents.default()

intents.message_content = True

client = discord.Client(intents=intents)

@client.event
async def on_ready():
    print("Bot is ready!")


