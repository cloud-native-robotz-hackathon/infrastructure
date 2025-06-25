 
#!/usr/bin/env python3

from picamera2 import Picamera2
import time
import os
from datetime import datetime # Still useful for print statements, but not filenames

def two_image_cycle_capture(output_directory="captured_images", delay_seconds=5):
    """
    Continuously captures images using Picamera2, maintaining only two files:
    image-new.jpg (the latest) and image-old.jpg (the previous).

    Args:
        output_directory (str): The directory where images will be saved.
                                Defaults to "captured_images".
        delay_seconds (int): The delay in seconds between capturing each image.
                             Defaults to 5 seconds.
    """
    picam2 = Picamera2()

    # Define the filenames
    new_image_name = "image-new.jpg"
    old_image_name = "image-old.jpg"

    # Full paths for the files
    new_image_path = os.path.join(output_directory, new_image_name)
    old_image_path = os.path.join(output_directory, old_image_name)

    # Ensure the output directory exists
    if not os.path.exists(output_directory):
        os.makedirs(output_directory)
        print(f"Created directory: {output_directory}")

    try:
        picam2.start()
        print(f"Starting two-image cycle capture. Files will be in '{output_directory}'.")
        print(f"Latest image: '{new_image_name}', Previous image: '{old_image_name}'")
        print(f"Press Ctrl+C to stop the capture.")

        while True:
            # --- Step 1: Rename the 'new' image to 'old' if it exists ---
            if os.path.exists(new_image_path):
                try:
                    # Remove the old 'image-old.jpg' if it exists to avoid FileExistsError on rename
                    if os.path.exists(old_image_path):
                        os.remove(old_image_path)
                        # print(f"Removed old '{old_image_name}'") # Uncomment for verbose logging

                    os.rename(new_image_path, old_image_path)
                    print(f"Renamed '{new_image_name}' to '{old_image_name}'")
                except Exception as e:
                    print(f"Error renaming {new_image_name} to {old_image_name}: {e}")
            else:
                print(f"'{new_image_name}' not found for renaming (first capture or previous error).")


            # --- Step 2: Capture the new image as 'image-new.jpg' ---
            try:
                picam2.capture_file(new_image_path)
                print(f"Captured new image as '{new_image_name}' at {datetime.now().strftime('%H:%M:%S')}")
            except Exception as e:
                print(f"Error capturing image to {new_image_name}: {e}")

            time.sleep(delay_seconds)

    except KeyboardInterrupt:
        print("\nTwo-image cycle capture stopped by user.")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
    finally:
        # Always stop the camera gracefully
        picam2.stop()
        print("Camera stopped.")

if __name__ == "__main__":
    # Example usage: Capture an image every 5 seconds
    two_image_cycle_capture(output_directory="my_live_feed", delay_seconds=1)
