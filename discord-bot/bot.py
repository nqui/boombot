import discord
import subprocess
import sys
import json

client = discord.Client()

@client.event
async def on_ready():
    print('We have logged in as {0.user}'.format(client))

@client.event
async def on_message(message):

    #print(message.content)

    if message.author == client.user:
        return

    elif message.content.startswith('-qq'):
        playlist_id = message.content.split()[1]
        track_list_bytes = subprocess.run(['pwsh.exe','C:\\Users\\nqui\\OneDrive\\nerd stuff\\development\\projects\\boombot\\spotify\\script.ps1',playlist_id],capture_output=True)
        track_list = json.loads(track_list_bytes.stdout.decode("utf-8").replace('\r','').replace('\n',''))
        if(track_list):
            print(f"track list from playlist id {playlist_id} is {track_list}")
            for track in track_list:
                response = f'-play {track["Artists"]} {track["TrackName"]}'
                print(response)
                await message.channel.send(response)

client.run('BOT_ACCESS_TOKEN_HERE')