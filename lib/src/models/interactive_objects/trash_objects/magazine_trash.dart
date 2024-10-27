import '../../enums/trash_type.dart';
import '../trash.dart';

class MagazineTrash extends Trash {
  MagazineTrash({required super.position})
    : super(trashType: TrashType.paper, spriteSrc: 'trash_objects/magazine.png');
}