import '../../enums/trash_type.dart';
import '../trash.dart';

class BananaTrash extends Trash {
  BananaTrash({required super.position})
    : super(trashType: TrashType.compost, spriteSrc: 'trash_objects/banana.png');
}