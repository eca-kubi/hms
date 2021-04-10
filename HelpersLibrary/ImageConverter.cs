using System.Drawing;
using System.IO;

namespace HelpersLibrary
{
    public class ImageConverter
    {
        public static byte[] imgToByteArray(Image img)
        {
            using (MemoryStream mStream = new MemoryStream())
            {
                img.Save(mStream, img.RawFormat);
                return mStream.ToArray();
            }
        }

        public static byte[] fromFile(string path)
        {
            Image img = Image.FromFile(path);
            return imgToByteArray(img);
        }
    }
}
