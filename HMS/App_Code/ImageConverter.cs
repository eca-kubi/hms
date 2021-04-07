using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;

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