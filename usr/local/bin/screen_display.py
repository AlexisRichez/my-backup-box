#!/opt/venv/bin/python3

import sys
print(sys.executable)
import time
import Adafruit_SSD1306

# Define display dimensions and I2C address
WIDTH = 128
HEIGHT = 64
I2C_ADDRESS = 0x3C

# Number of lines to display
NUM_LINES = 4

# Initialize display
disp = Adafruit_SSD1306.SSD1306_128_64(rst=None)
disp.begin()
disp.clear()
disp.display()

# Display message on the OLED
def display_message(message):
    disp.clear()
    disp.display()
    width = disp.width
    height = disp.height
    image = Adafruit_SSD1306.Image.new('1', (width, height))
    draw = Adafruit_SSD1306.ImageDraw.Draw(image)
    
    lines = message.split('\n')  # Split message into lines
    
    # Write each line to the display
    for i, line in enumerate(lines):
        draw.text((0, i*8), line, font=Adafruit_SSD1306.ImageFont.load_default(), fill=255)
    
    # Display the image
    disp.image(image)
    disp.display()

# Main function
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python display_info.py <message>")
        sys.exit(1)
    message = " ".join(sys.argv[1:])
    display_message(message)
    time.sleep(5)  # Display message for 5 seconds
